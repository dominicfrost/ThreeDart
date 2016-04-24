part of ThreeDart.Lights;

/// Storage for spot light data.
class Spot implements Light {

  /// Creates a new spot light data.
  Spot({
      Movers.Mover mover: null,
      Math.Color4 color: null,
      double penumbra: null,
      double umbra: null,
      double attenuation0: null,
      double attenuation1: null,
      double attenuation2: null}) {
    this.mover        = mover;
    this.color        = color;
    this.penumbra     = penumbra;
    this.umbra        = umbra;
    this.attenuation0 = attenuation0;
    this.attenuation1 = attenuation1;
    this.attenuation2 = attenuation2;
    this._position    = new Math.Point3(0.0, 0.0, 0.0);
    this._direction   = new Math.Vector3(0.0, 0.0, 1.0);
  }

  /// Updates the light with the current state.
  void update(Core.RenderState state) {
    this._position  = new Math.Point3(0.0, 0.0, 0.0);
    this._direction = new Math.Vector3(0.0, 0.0, 1.0);
    if (this._mover != null) {
      Math.Matrix4 mat = this._mover.update(state, this);
      if (mat != null) {
        this._position  = mat.transPnt3(this._position);
        this._direction = mat.transVec3(this._direction);
      }
    }
  }

  /// The location the light.
  Math.Point3 get position => this._position;
  Math.Point3 _position;

  /// The direction the light is pointing.
  Math.Vector3 get direction => this._direction;
  Math.Vector3 _direction;

  /// The mover to position this light.
  Movers.Mover get mover => this._mover;
  set mover(Movers.Mover mover) => this._mover = mover;
  Movers.Mover _mover;

  /// The color of the light.
  Math.Color4 get color => this._color;
  set color(Math.Color4 color) =>
    this._color = (color == null)? new Math.Color4.white(): color;
  Math.Color4 _color;

  /// The penumbra of the light.
  double get penumbra => this._penumbra;
  set penumbra(double penumbra) =>
    this._penumbra = (penumbra == null)? math.PI:
    Math.clampVal(penumbra, 0.0, math.PI);
  double _penumbra;

  /// The umbra of the light.
  double get umbra => this._umbra;
  set umbra(double umbra) =>
    this._umbra = (umbra == null)? math.PI:
    Math.clampVal(umbra, 0.0, math.PI);
  double _umbra;

  /// The constant attenuation factor of the light.
  double get attenuation0 => this._attenuation0;
  set attenuation0(double attenuation0) =>
    this._attenuation0 = (attenuation0 == null)? 1.0: attenuation0;
  double _attenuation0;

  /// The linear attenuation factor of the light.
  double get attenuation1 => this._attenuation1;
  set attenuation1(double attenuation1) =>
    this._attenuation1 = (attenuation1 == null)? 0.0: attenuation1;
  double _attenuation1;

  /// The quadratic attenuation factor of the light.
  double get attenuation2 => this._attenuation2;
  set attenuation2(double attenuation2) =>
    this._attenuation2 = (attenuation2 == null)? 0.0: attenuation2;
  double _attenuation2;
}
