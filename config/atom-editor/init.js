getPackageList = (type) => {
	return atom.packages.getLoadedPackages()
		.filter(p => !p.bundledPackage)
		.filter(p => p.__proto__.constructor.name == type)
		.map(p => p.name)
}

savePackageList = () => {
	atom.config.set('backup.packages', getPackageList('Package').sort())
	atom.config.set('backup.themes', getPackageList('ThemePackage').sort())
}

restorePackageList = () => {
	ref = require('atom')

	installedPackages = getPackageList('Package')
	installedThemes = getPackageList('ThemePackage')

	packages = atom.config.get('backup.packages')
		.filter(p => !installedPackages.includes(p))
	themes = atom.config.get('backup.themes')
		.filter(t => !installedThemes.includes(t))

	installPackage = (name, theme = false) => {
		enabled = !theme && !atom.packages.isPackageDisabled(name)

		command = atom.packages.getApmPath()
		args = ['install', name, '--json']
		args.push('--no-color')
		return new Promise((resolve, reject) => new ref.BufferedProcess({
			command, args,
			exit: (code) => code && reject() || resolve(),
		})).then(() => {
			if (!enabled) {
				atom.packages.disablePackage(name)
			}
		})
	}

	console.log(installedPackages, packages)
	console.log(installedThemes, themes)

	return Promise.all([
		...packages.map(p => {
			return installPackage({ name: p })
		}),
		...themes.map(t => {
			return installPackage({ name: t, theme: true })
		}),
	])
}

atom.packages.onDidActivateInitialPackages(() => {
	const register = () => {
		atom.packages.onDidActivatePackage(savePackageList)
		atom.packages.onDidDeactivatePackage(savePackageList)
		atom.packages.onDidLoadPackage(savePackageList)
		atom.packages.onDidUnloadPackage(savePackageList)
	}

	restorePackageList().then(register, register)
})
