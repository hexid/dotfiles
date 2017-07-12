getPackageList = (type) => {
	return atom.packages.getActivePackages()
		.filter(p => !p.bundledPackage)
		.filter(p => p.__proto__.constructor.name == type)
		.map(p => p.name)
}

savePackageList = () => {
	atom.config.set('backup.packages', getPackageList('Package'))
	atom.config.set('backup.themes', getPackageList('ThemePackage'))
}

restorePackageList = () => {
	ref = require('atom')

	installedPackages = getPackageList('Package')
	installedThemes = getPackageList('ThemePackage')

	packages = atom.config.get('backup.packages')
		.filter(p => !installedPackages.includes(p))
	themes = atom.config.get('backup.themes')
		.filter(t => !installedThemes.includes(t))

	installPackage = (pack, callback) => {
		name = pack.name
		theme = pack.theme || false
		activateOnSuccess = !theme && !atom.packages.isPackageDisabled(name)

		command = atom.packages.getApmPath()
		args = ['install', name, '--json']

		outputLines = []
		stdout = (lines) => outputLines.push(lines)
		errorLines = []
		stderr = (lines) => errorLines.push(lines)
		exit = (code) => callback(code, outputLines.join('\n'), errorLines.join('\n'))

		args.push('--no-color')
		return new ref.BufferedProcess({command, args, stdout, stderr, exit})
	}

	packages.forEach(p => {
		installPackage({ name: p }, (code, out, err) => {
			console.log(code)
		})
	})

	themes.forEach(t => {
		installPackage({ name: t, theme: true }, (code, out, err) => {
			console.log(code)
		})
	})

	console.log(packages, themes)
}

restorePackageList()

atom.packages.onDidActivatePackage(savePackageList)
atom.packages.onDidDeactivatePackage(savePackageList)
atom.packages.onDidLoadPackage(savePackageList)
atom.packages.onDidUnloadPackage(savePackageList)
