// Copyright (c) 2016, SnowGremlin. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library ThreeDart.test.test031;

import 'dart:html';

import 'package:ThreeDart/ThreeDart.dart' as ThreeDart;
import 'package:ThreeDart/Shapes.dart' as Shapes;
import 'package:ThreeDart/Movers.dart' as Movers;
import 'package:ThreeDart/Math.dart' as Math;
import 'package:ThreeDart/Techniques.dart' as Techniques;
import 'package:ThreeDart/Scenes.dart' as Scenes;
import 'package:ThreeDart/Views.dart' as Views;
import 'package:ThreeDart/Lights.dart' as Lights;
import '../common/common.dart' as common;

void main() {
  common.shellTest("Test 031", [],
    "A test of the Distortion cover with a dynamic normal map. "+
    "The distortion map is generated into one back buffer. "+
    "The scene is generated into another back buffer. "+
    "The two parts are combined with a Distortion cover. "+
    "Use mouse to rotate cube in normal map and Ctrl plus mouse "+
    "to rotate scene.");

  ThreeDart.ThreeDart td = new ThreeDart.ThreeDart.fromId("threeDart");

  ThreeDart.Entity normalObj = new ThreeDart.Entity()
    ..shape = Shapes.cube()
    ..mover = (new Movers.Group()
      ..add(new Movers.UserRotater(input: td.userInput))
      ..add(new Movers.UserZoom(input: td.userInput)));

  Techniques.Normal normalTech = new Techniques.Normal()
    ..bumpyTextureCube = td.textureLoader.loadCubeFromPath("../resources/diceBumpMap");

  Views.BackTarget normalTarget = new Views.BackTarget(800, 600)
    ..color = new Math.Color4(0.5, 0.5, 1.0, 1.0);

  Scenes.EntityPass normalPass = new Scenes.EntityPass()
    ..tech = normalTech
    ..target = normalTarget
    ..children.add(normalObj)
    ..camera.mover = new Movers.Constant(new Math.Matrix4.translate(0.0, 0.0, 5.0));

  Movers.Group secondMover = new Movers.Group()
  ..add(new Movers.UserRotater(ctrl: true, input: td.userInput))
  ..add(new Movers.UserZoom(ctrl: true, input: td.userInput))
  ..add(new Movers.Constant(new Math.Matrix4.translate(0.0, 0.0, 5.0)));
  Views.Perspective userCamera = new Views.Perspective(mover: secondMover);

  Views.BackTarget colorTarget = new Views.BackTarget(800, 600)
    ..clearColor = false;

  ThreeDart.Entity colorObj = new ThreeDart.Entity()
    ..shape = Shapes.toroid();

  Techniques.MaterialLight colorTech = new Techniques.MaterialLight()
    ..lights.add(new Lights.Directional(
          mover: new Movers.Constant(new Math.Matrix4.vectorTowards(0.0, -1.0, -1.0)),
          color: new Math.Color3.white()))
    ..ambient.color = new Math.Color3(0.0, 0.0, 1.0)
    ..diffuse.color = new Math.Color3(0.0, 1.0, 0.0)
    ..specular.color = new Math.Color3(1.0, 0.0, 0.0)
    ..specular.shininess = 10.0;

  Scenes.CoverPass skybox = new Scenes.CoverPass.skybox(
    td.textureLoader.loadCubeFromPath("../resources/maskonaive", ext: ".jpg"))
    ..target = colorTarget
    ..camera = userCamera;

  Scenes.EntityPass colorPass = new Scenes.EntityPass()
    ..camera = userCamera
    ..tech = colorTech
    ..target = colorTarget
    ..children.add(colorObj);

  Techniques.Distort distortTech = new Techniques.Distort()
    ..colorTexture = colorTarget.colorTexture
    ..bumpTexture = normalTarget.colorTexture
    ..bumpMatrix = new Math.Matrix4.scale(0.05, 0.05, 0.05);
  Scenes.CoverPass distortPass = new Scenes.CoverPass()
    ..tech = distortTech;

  Techniques.TextureLayout layoutTech = new Techniques.TextureLayout()
    ..entries.add(new Techniques.TextureLayoutEntry(
      texture: normalTarget.colorTexture,
      destination: new Math.Region2(0.0, 0.8, 0.2, 0.2),
      flip: true))
    ..entries.add(new Techniques.TextureLayoutEntry(
      texture: colorTarget.colorTexture,
      destination: new Math.Region2(0.0, 0.6, 0.2, 0.2)));
  Scenes.CoverPass layout = new Scenes.CoverPass()
    ..target = new Views.FrontTarget(clearColor: false)
    ..tech = layoutTech;

  td.scene = new Scenes.Compound(passes: [skybox, colorPass, normalPass, distortPass, layout]);

  var update;
  update = (num t) {
    td.render();
    window.requestAnimationFrame(update);
  };
  window.requestAnimationFrame(update);
}
