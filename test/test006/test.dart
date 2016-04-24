// Copyright (c) 2015-2016, SnowGremlin. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library ThreeDart.test.test006;

import 'dart:html';

import 'package:ThreeDart/ThreeDart.dart' as ThreeDart;
import 'package:ThreeDart/Shapes.dart' as Shapes;
import 'package:ThreeDart/Movers.dart' as Movers;
import 'package:ThreeDart/Math.dart' as Math;
import 'package:ThreeDart/Techniques.dart' as Techniques;
import 'package:ThreeDart/Scenes.dart' as Scenes;
import 'package:ThreeDart/Lights.dart' as Lights;
import '../common/common.dart' as common;

void main() {
  common.shellTest("Test 006", ["bumpMaps"],
    "A test of the Bumpy Texture 2D Directional Lighting Shader.");

  Shapes.Shape shape = Shapes.cube();

  Techniques.MaterialLight tech = new Techniques.MaterialLight()
    ..lights.add(new Lights.Directional(
        mover: new Movers.Constant(new Math.Matrix4.vectorTowards(0.0, 0.0, -1.0)),
        color: new Math.Color3.white()));

  ThreeDart.Entity objTech = new ThreeDart.Entity()
    ..shape = shape
    ..technique = tech;

  ThreeDart.Entity objInspecTech = new ThreeDart.Entity()
    ..shape = shape
    ..technique = (new Techniques.Inspection()
        ..vectorScale = 0.4
        ..showWireFrame = true
        ..showAxis = true
        ..showNormals = true
        ..showBinormals = true);

  Movers.UserRotater rotater = new Movers.UserRotater();
  Movers.UserZoom zoom = new Movers.UserZoom();
  Movers.UserRoller roller = new Movers.UserRoller()
    ..ctrlPressed = true;

  ThreeDart.Entity group = new ThreeDart.Entity()
    ..children.add(objInspecTech)
    ..children.add(objTech)
    ..mover = (new Movers.Group()
      ..add(rotater)
      ..add(roller)
      ..add(zoom));

  Scenes.RenderPass pass = new Scenes.RenderPass()
    ..children.add(group)
    ..camara.mover = new Movers.Constant(new Math.Matrix4.translate(0.0, 0.0, 5.0));

  ThreeDart.ThreeDart td = new ThreeDart.ThreeDart.fromId("threeDart")
    ..scene = pass;

  tech
    ..ambientColor = new Math.Color3(0.0, 0.0, 1.0)
    ..diffuseColor = new Math.Color3(0.0, 1.0, 0.0)
    ..specularColor = new Math.Color3(1.0, 0.0, 0.0)
    ..shininess = 10.0;

  rotater.attach(td.userInput);
  zoom.attach(td.userInput);
  roller.attach(td.userInput);

  new common.Texture2DGroup("bumpMaps", (String fileName) {
    tech.bumpyTexture2D = td.textureLoader.load2DFromFile(fileName);
  })
    ..add("../resources/BumpMap1.png", true)
    ..add("../resources/BumpMap2.png")
    ..add("../resources/BumpMap3.png")
    ..add("../resources/BumpMap4.png")
    ..add("../resources/BumpMap5.png")
    ..add("../resources/ScrewBumpMap.png")
    ..add("../resources/CtrlPnlBumpMap.png");

  var update;
  update = (num t) {
    td.render();
    window.requestAnimationFrame(update);
  };
  window.requestAnimationFrame(update);
}
