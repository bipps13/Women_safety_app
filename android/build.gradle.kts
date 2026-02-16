import org.gradle.api.tasks.Delete

allprojects {
    repositories {
        google
        mavenCentral()
    }
}

/**
 * 🔧 Move build directory outside android/flutter run
 * (Flutter recommended)
 */
val rootBuildDir = layout.buildDirectory.dir("../../build")

layout.buildDirectory.set(rootBuildDir)

/**
 * 🔧 Each subproject gets its own build folder
 */
subprojects {
    layout.buildDirectory.set(rootBuildDir.map { it.dir(name) })
}

/**
 * 🔧 Ensure :app is evaluated first
 */
subprojects {
    evaluationDependsOn(":app")
}

/**
 * 🧹 Clean task
 */
tasks.register<Delete>("clean") {
    delete(layout.buildDirectory)
}
