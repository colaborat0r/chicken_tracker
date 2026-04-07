allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// AGP 8+ requires a namespace for every Android module.
// Some older Flutter plugins still omit it, so set a fallback namespace.
subprojects {
    plugins.withId("com.android.library") {
        val androidExt = extensions.findByName("android") ?: return@withId
        val getNamespace = androidExt.javaClass.methods.find { it.name == "getNamespace" }
        val currentNamespace = getNamespace?.invoke(androidExt) as? String

        if (currentNamespace.isNullOrBlank()) {
            val setNamespace = androidExt.javaClass.methods.find {
                it.name == "setNamespace" && it.parameterTypes.size == 1
            }

            val fallbackNamespace = "com.example.${project.name.replace('-', '_')}"
            setNamespace?.invoke(androidExt, fallbackNamespace)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
