import QtQuick
import QtQuick.Particles
import QtQuick.Layouts
import "../Data/" as Dat
// god bless sormane for his raining kuru kuru example
// https://github.com/soramanew/rainingkuru
ParticleSystem {
  id: root

  required property real rateMultiplier
  running: false

  ImageParticle {
    autoRotation: true
    color: "#653BE0"
    colorVariation: 0.3
    entryEffect: ImageParticle.Fade
    groups: ["kuru"]
    rotationVariation: 360
    source: "qrc:///particleresources/star.png"
  }

  Emitter {
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.rightMargin: 30 * Dat.Globals.notchScale
    emitRate: 120 * (Math.min(root.rateMultiplier - 5.5, 5))
    endSize: 0
    group: "kuru"
    height: 10 * Dat.Globals.notchScale
    lifeSpan: 5000
    lifeSpanVariation: 1000
    size: 20 * Dat.Globals.notchScale
    sizeVariation: 30 * Dat.Globals.notchScale
    width: 100 * Dat.Globals.notchScale

    velocity: AngleDirection {
      angleVariation: 360
      magnitude: 120 * Dat.Globals.notchScale
      magnitudeVariation: 20 * Dat.Globals.notchScale
    }

  }
}
