// Generated by CoffeeScript 1.6.3
(function() {
  var CELL_SIZE, Canvas, FPS, Field, LifeGame, SCREEN_SIZE, SIDE_CELLS,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  SCREEN_SIZE = 500;

  SIDE_CELLS = 200;

  CELL_SIZE = SCREEN_SIZE / SIDE_CELLS;

  FPS = 10;

  Field = (function(_super) {
    __extends(Field, _super);

    function Field() {
      var i, _i, _ref;
      for (i = _i = 0, _ref = SIDE_CELLS * SIDE_CELLS; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        this.push(Math.floor(Math.random() * 2));
      }
    }

    Field.prototype.clone = function() {
      return this.slice();
    };

    return Field;

  })(Array);

  Canvas = (function() {
    function Canvas() {
      var k, _i, _len, _ref;
      this.cvs = document.getElementById(this.id);
      this.scaleRate = Math.min(window.innerWidth / SCREEN_SIZE, window.innerHeight / SCREEN_SIZE);
      _ref = ['width', 'height'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        k = _ref[_i];
        this.cvs[k] = SCREEN_SIZE;
        this.cvs.style[k] = SCREEN_SIZE * this.scaleRate + 'px';
      }
      this.ctx = this.cvs.getContext('2d');
      this.ctx.fillStyle = this.style;
    }

    Canvas.prototype.id = 'world';

    Canvas.prototype.style = 'rgb(211,85,149)';

    Canvas.prototype.draw = function(field) {
      var i, x, y, _i, _ref;
      this.ctx.clearRect(0, 0, SCREEN_SIZE, SCREEN_SIZE);
      for (i = _i = 0, _ref = field.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        x = (i % SIDE_CELLS) * CELL_SIZE;
        y = Math.floor(i / SIDE_CELLS) * CELL_SIZE;
        if (field[i]) {
          this.ctx.fillRect(x, y, CELL_SIZE, CELL_SIZE);
        }
      }
    };

    return Canvas;

  })();

  LifeGame = (function() {
    function LifeGame() {
      this.field = new Field();
      this.canvas = new Canvas();
    }

    LifeGame.prototype.field = [];

    LifeGame.prototype.tempField = [];

    LifeGame.prototype.canvas = null;

    LifeGame.prototype.update = function() {
      var c, i, s, self, surviver, t, _i, _j, _k, _ref;
      surviver = 0;
      this.tempField = this.field.clone();
      for (i = _i = 0, _ref = this.tempField.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        surviver = 0;
        for (s = _j = -1; _j <= 1; s = ++_j) {
          for (t = _k = -1; _k <= 1; t = ++_k) {
            if (s === 0 && t === 0) {
              continue;
            }
            c = i + s * SIDE_CELLS + t;
            if (c >= 0 && c < this.tempField.length) {
              if ((i < c && c % SIDE_CELLS !== 0) || (i > c && c % SIDE_CELLS !== SIDE_CELLS - 1)) {
                if (this.tempField[c]) {
                  surviver++;
                }
              }
            }
          }
        }
        if (this.tempField[i] && (surviver === 2 || surviver === 3)) {
          this.field[i] = 1;
        } else if (!this.tempField[i] && surviver === 3) {
          this.field[i] = 1;
        } else {
          this.field[i] = 0;
        }
      }
      this.canvas.draw(this.field);
      self = this;
      return setTimeout(function() {
        return self.update();
      }, 1000 / FPS);
    };

    return LifeGame;

  })();

  window.onload = function() {
    var lifeGame;
    lifeGame = new LifeGame();
    lifeGame.update();
  };

}).call(this);
