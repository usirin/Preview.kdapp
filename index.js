/* Compiled by kdc on Sat May 24 2014 01:39:41 GMT+0000 (UTC) */
(function() {
/* KDAPP STARTS */
/* BLOCK STARTS: helpers.coffee */
var PreviewHelpers;

PreviewHelpers = {
  isImage: function(file) {
    return _.contains(["jpg", "gif", "png"], file.getExtension());
  },
  isMusic: function(file) {
    return _.contains(["mp3", "m4a", "ogg"], file.getExtension());
  },
  isVideo: function(file) {
    return _.contains(["mp4", "ogg"], file.getExtension());
  },
  prettifyJson: function(content, fileExtension) {
    if (fileExtension !== "json") {
      return content;
    }
    content = JSON.parse(content);
    return JSON.stringify(content, void 0, 2);
  },
  normalize: function(number) {
    if (number < 10) {
      return "0" + number;
    } else {
      return "" + number;
    }
  },
  formatDate: function(dateString) {
    var date, dateOfMonth, day, days, hour, minute, month, months, normalize, year;
    days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    normalize = PreviewHelpers.normalize;
    date = new Date(dateString);
    day = days[date.getDay()];
    month = months[date.getMonth()];
    dateOfMonth = normalize(date.getDate());
    year = normalize(date.getFullYear());
    hour = normalize(date.getHours());
    minute = normalize(date.getMinutes());
    return "" + day + ", " + month + " " + dateOfMonth + ", " + year + " at " + hour + ":" + minute;
  }
};
/* BLOCK STARTS: generators/base-file.coffee */
var BaseFile;

BaseFile = (function() {
  function BaseFile(src, file, panel) {
    this.src = src;
    this.file = file;
    this.panel = panel;
    this.vmController = KD.singletons.vmController;
    this.webPath = "/home/" + (KD.nick()) + "/Web/";
  }

  BaseFile.prototype.random = function() {
    return KD.utils.getRandomNumber(1e21);
  };

  BaseFile.prototype.mime = function() {
    return "";
  };

  BaseFile.prototype.webPrefix = function() {
    return "";
  };

  BaseFile.prototype.create = function(src, file) {
    return false;
  };

  BaseFile.prototype.generate = function() {
    return this.link();
  };

  BaseFile.prototype.link = function() {
    var destinationPath, linkName, path,
      _this = this;
    path = FSHelper.plainPath(this.file.path);
    linkName = "" + (this.webPrefix()) + "." + (this.random()) + "." + (this.file.getExtension());
    destinationPath = "" + this.webPath + linkName;
    return this.vmController.run("ln -s " + path + " " + destinationPath).then(function(resolve) {
      var publicPath;
      publicPath = "//" + (KD.nick()) + ".kd.io/" + linkName;
      return _this.create(publicPath);
    });
  };

  BaseFile.prototype.base64src = function(src) {
    return "data:" + (this.mime()) + ";base64," + src;
  };

  return BaseFile;

})();
/* BLOCK STARTS: generators/preview-code.coffee */
var PreviewCode, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

PreviewCode = (function(_super) {
  __extends(PreviewCode, _super);

  function PreviewCode() {
    _ref = PreviewCode.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  PreviewCode.prototype.create = function(src, file) {
    var _this = this;
    return this.file.fetchContents().then(function(resolve, reject) {
      var content;
      _this.element = new KDCustomHTMLView({
        tagName: "pre",
        cssClass: "code"
      });
      content = PreviewHelpers.prettifyJson(resolve, _this.file.getExtension());
      _this.element.addSubView(new KDCustomHTMLView({
        tagName: "code",
        partial: hljs.highlightAuto(content).value
      }));
      KD.utils.defer(function() {
        return _this.panel.loader.hide();
      });
      return _this.element;
    });
  };

  PreviewCode.prototype.link = function() {
    var _this = this;
    return new Promise(function(resolve, reject) {
      return resolve(_this.create());
    });
  };

  return PreviewCode;

})(BaseFile);
/* BLOCK STARTS: generators/preview-markdown.coffee */
var PreviewMarkdown, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

PreviewMarkdown = (function(_super) {
  __extends(PreviewMarkdown, _super);

  function PreviewMarkdown() {
    _ref = PreviewMarkdown.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  PreviewMarkdown.prototype.create = function(src, file) {
    var _this = this;
    return this.file.fetchContents().then(function(resolve, reject) {
      _this.element = new KDCustomHTMLView({
        cssClass: "markdown",
        partial: KD.utils.applyMarkdown(resolve)
      });
      KD.utils.defer(function() {
        return _this.panel.loader.hide();
      });
      return _this.element;
    });
  };

  PreviewMarkdown.prototype.link = function() {
    var _this = this;
    return new Promise(function(resolve, reject) {
      return resolve(_this.create());
    });
  };

  return PreviewMarkdown;

})(BaseFile);
/* BLOCK STARTS: generators/preview-image.coffee */
var PreviewImage, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

PreviewImage = (function(_super) {
  __extends(PreviewImage, _super);

  function PreviewImage() {
    _ref = PreviewImage.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  PreviewImage.prototype.mime = function() {
    return "image/" + (this.image.getExtension());
  };

  PreviewImage.prototype.webPrefix = function() {
    return ".kd.link-image";
  };

  PreviewImage.prototype.create = function(src, image) {
    var _this = this;
    src || (src = this.base64Src());
    this.img = new KDCustomHTMLView({
      tagName: "img",
      cssClass: "preview-img",
      bind: "load error",
      attributes: {
        src: src
      }
    });
    this.img.once("load", function() {
      return _this.panel.loader.hide();
    });
    this.img.once("error", function() {
      return _this.panel.loader.hide();
    });
    return this.img;
  };

  return PreviewImage;

})(BaseFile);
/* BLOCK STARTS: generators/preview-music.coffee */
var PreviewMusic, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

PreviewMusic = (function(_super) {
  __extends(PreviewMusic, _super);

  function PreviewMusic() {
    _ref = PreviewMusic.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  PreviewMusic.prototype.mime = function() {
    return "audio/" + (this.music.getExtension());
  };

  PreviewMusic.prototype.webPrefix = function() {
    return ".kd.link-music";
  };

  PreviewMusic.prototype.create = function(src, music) {
    var _this = this;
    src || (src = this.base64Src());
    this.music = new KDCustomHTMLView({
      tagName: "audio",
      cssClass: "preview-music",
      bind: "loadeddata error",
      attributes: {
        src: src,
        controls: true,
        autoplay: true
      }
    });
    this.music.once("loadeddata", function() {
      return _this.panel.loader.hide();
    });
    this.music.once("error", function() {
      return _this.panel.loader.hide();
    });
    return this.music;
  };

  return PreviewMusic;

})(BaseFile);
/* BLOCK STARTS: generators/preview-video.coffee */
var PreviewVideo, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

PreviewVideo = (function(_super) {
  __extends(PreviewVideo, _super);

  function PreviewVideo() {
    _ref = PreviewVideo.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  PreviewVideo.prototype.mime = function() {
    return "video/" + (this.video.getExtension());
  };

  PreviewVideo.prototype.webPrefix = function() {
    return ".kd.link-video";
  };

  PreviewVideo.prototype.create = function(src, video) {
    var _this = this;
    src || (src = this.base64Src());
    this.video = new KDCustomHTMLView({
      tagName: "video",
      cssClass: "preview-video",
      bind: "loadeddata error",
      attributes: {
        src: src,
        controls: true,
        autoplay: true,
        width: "auto",
        height: "auto"
      }
    });
    this.video.once("loadeddata", function() {
      return _this.panel.loader.hide();
    });
    this.video.once("error", function() {
      return _this.panel.loader.hide();
    });
    return this.video;
  };

  return PreviewVideo;

})(BaseFile);
/* BLOCK STARTS: generators/preview-file.coffee */
var PreviewFile, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

PreviewFile = (function(_super) {
  __extends(PreviewFile, _super);

  function PreviewFile() {
    _ref = PreviewFile.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  PreviewFile.prototype.fontAwesomeLetter = function(fileType) {
    var typeToLetterMap;
    typeToLetterMap = {
      code: "&#xf1c9;",
      text: "&#xf0f6;",
      archive: "&#xf1c6;",
      unknown: "&#xf016;"
    };
    return typeToLetterMap[fileType];
  };

  PreviewFile.prototype.create = function(src, file) {
    var extension, faLetter, type,
      _this = this;
    extension = this.file.getExtension();
    type = FSFile.getFileType(extension);
    faLetter = this.fontAwesomeLetter(type);
    this.element = new KDCustomHTMLView({
      tagName: "div",
      cssClass: "file-thumb",
      partial: faLetter,
      bind: "load error"
    });
    KD.utils.defer(function() {
      return _this.panel.loader.hide();
    });
    return this.element;
  };

  PreviewFile.prototype.link = function() {
    var _this = this;
    return new Promise(function(resolve, reject) {
      return resolve(_this.create());
    });
  };

  return PreviewFile;

})(BaseFile);
/* BLOCK STARTS: controllers/main.coffee */
var PreviewController,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

PreviewController = (function(_super) {
  __extends(PreviewController, _super);

  function PreviewController(options, data) {
    if (options == null) {
      options = {};
    }
    options.view = new PreviewMainView;
    options.appInfo = {
      name: "Preview",
      type: "application"
    };
    PreviewController.__super__.constructor.call(this, options, data);
  }

  return PreviewController;

})(AppController);
/* BLOCK STARTS: views/details-item.coffee */
var PreviewDetailsItem,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

PreviewDetailsItem = (function(_super) {
  __extends(PreviewDetailsItem, _super);

  function PreviewDetailsItem(options, data) {
    if (options == null) {
      options = {};
    }
    options.cssClass = KD.utils.curry("details-item", options.cssClass);
    if (data.propName == null) {
      data.propName = "";
    }
    if (data.propData == null) {
      data.propData = "";
    }
    PreviewDetailsItem.__super__.constructor.call(this, options, data);
    this.hide();
  }

  PreviewDetailsItem.prototype.pistachio = function() {
    return "<div class=\"prop\">{{ #(propName) }}</div>\n<div class=\"prop-data\">{{ #(propData) }}</div>\n<div style=\"clear: both\"></div>";
  };

  PreviewDetailsItem.prototype.updateData = function(data) {
    var key, oldData, value;
    if (typeof data !== "object") {
      return;
    }
    oldData = this.getData();
    for (key in data) {
      value = data[key];
      oldData[key] = value;
    }
    return this.setData(oldData);
  };

  return PreviewDetailsItem;

})(JView);
/* BLOCK STARTS: views/preview.coffee */
var PreviewView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

PreviewView = (function(_super) {
  __extends(PreviewView, _super);

  function PreviewView(options, data) {
    var _this = this;
    if (options == null) {
      options = {};
    }
    options.cssClass = "preview-panel";
    PreviewView.__super__.constructor.call(this, options, data);
    this.createPlaceholder();
    this.loader = new KDLoaderView({
      size: {
        width: 48
      }
    });
    KD.utils.defer(function() {
      return _this.addSubView(_this.loader);
    });
  }

  PreviewView.prototype.createName = function(name) {
    this.name || (this.name = new KDView({
      cssClass: "preview-img-name"
    }));
    return this.name.updatePartial(name);
  };

  PreviewView.prototype.destroyAll = function() {
    var _ref;
    this.loader.show();
    return (_ref = this.item) != null ? _ref.destroy() : void 0;
  };

  PreviewView.prototype.createPlaceholder = function() {
    var _this = this;
    this.placeholder = new KDCustomHTMLView({
      tagName: "div",
      cssClass: "preview-placeholder"
    });
    return KD.utils.defer(function() {
      _this.addSubView(_this.placeholder);
      return _this.placeholder.hide();
    });
  };

  PreviewView.prototype.addAll = function() {
    var _this = this;
    return KD.utils.defer(function() {
      _this.placeholder.show();
      _this.placeholder.addSubView(_this.item);
      if (!_this.name) {
        return _this.placeholder.addSubView(_this.name);
      }
    });
  };

  PreviewView.prototype.generate = function(options) {
    var file, generator,
      _this = this;
    generator = options.generator, file = options.file;
    this.destroyAll();
    return file.fetchRawContents().then(function(resolve, reject) {
      return (new generator(resolve.content, file, _this)).generate().then(function(item) {
        _this.item = item;
        _this.createName(file.name);
        return _this.addAll();
      });
    }, function(err) {
      return (new generator(null, file, _this)).generate().then(function(item) {
        _this.item = item;
        _this.createName(file.name);
        return _this.addAll();
      });
    });
  };

  return PreviewView;

})(JView);
/* BLOCK STARTS: views/details.coffee */
var PreviewDetails,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

PreviewDetails = (function(_super) {
  __extends(PreviewDetails, _super);

  function PreviewDetails(options, data) {
    if (options == null) {
      options = {};
    }
    options.cssClass = "preview-details";
    PreviewDetails.__super__.constructor.call(this, options, data);
    this.nameView = new PreviewDetailsItem({
      cssClass: "details-name"
    }, {
      propName: "Name"
    });
    this.sizeView = new PreviewDetailsItem({
      cssClass: "details-size"
    }, {
      propName: "Size"
    });
    this.dateView = new PreviewDetailsItem({
      cssClass: "details-date"
    }, {
      propName: "Created"
    });
  }

  PreviewDetails.prototype.update = function(file) {
    this.file = file;
    return this.updateView();
  };

  PreviewDetails.prototype.pistachio = function() {
    return "{{> this.nameView }}\n{{> this.sizeView }}\n{{> this.dateView }}";
  };

  PreviewDetails.prototype.updateView = function() {
    var formatDate;
    formatDate = PreviewHelpers.formatDate;
    this.nameView.show().updateData({
      propData: this.file.name
    });
    this.sizeView.show().updateData({
      propData: KD.utils.formatBytesToHumanReadable(this.file.size)
    });
    return this.dateView.show().updateData({
      propData: formatDate(this.file.createdAt)
    });
  };

  return PreviewDetails;

})(JView);
/* BLOCK STARTS: views/area.coffee */
var PreviewArea,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

PreviewArea = (function(_super) {
  __extends(PreviewArea, _super);

  function PreviewArea(options, data) {
    var _this = this;
    if (options == null) {
      options = {};
    }
    PreviewArea.__super__.constructor.call(this, options, data);
    this.addSubView(this.preview = new PreviewView);
    this.addSubView(this.details = new PreviewDetails);
    this.on("FileSelected", function(file) {
      var generator;
      generator = _this.getGenerator(file);
      _this.preview.generate({
        generator: generator,
        file: file
      });
      return _this.details.update(file);
    });
  }

  PreviewArea.prototype.getGenerator = function(file) {
    var ext, generator, markdownExtensions;
    markdownExtensions = ["markdown", "mdown", "mkdn", "md", "mkd", "mdwn", "mdtxt", "mdtext", "text"];
    ext = file.getExtension();
    return generator = (function() {
      switch (FSFile.getFileType(ext)) {
        case "image":
          return PreviewImage;
        case "video":
          return PreviewVideo;
        case "sound":
          return PreviewMusic;
        case "code":
          return PreviewCode;
        default:
          return (function() {
            if (ext === "rb") {
              return PreviewCode;
            } else if (_.contains(markdownExtensions, ext)) {
              return PreviewMarkdown;
            } else {
              return PreviewFile;
            }
          })();
      }
    })();
  };

  return PreviewArea;

})(KDView);
/* BLOCK STARTS: views/finder.coffee */
var PreviewFinder,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

PreviewFinder = (function(_super) {
  __extends(PreviewFinder, _super);

  PreviewFinder.prototype.webPrefix = ".kd.link";

  function PreviewFinder(options, data) {
    var _this = this;
    if (options == null) {
      options = {};
    }
    options.cssClass = KD.utils.curry("custom-icons", options.cssClass);
    this.vmController = KD.getSingleton("vmController");
    this.cleanOlderFiles();
    PreviewFinder.__super__.constructor.call(this, options, data);
    this.vmController.fetchDefaultVmName(function(vmName) {
      _this.finder = new NFinderController({
        nodeIdPath: "path",
        nodeParentIdPath: "parentPath",
        contextMenu: true,
        useStorage: false,
        bind: "keydown"
      });
      _this.addSubView(_this.finder.getView());
      _this.finder.updateVMRoot(vmName, "/home/" + (KD.nick()));
      return _this.finder.on("FileNeedsToBeOpened", function(file) {
        var mainView;
        _this.cleanOlderFiles();
        mainView = _this.getDelegate();
        return mainView.emit("FileSelected", file);
      });
    });
  }

  PreviewFinder.prototype.cleanOlderFiles = function() {
    return this.vmController.run("rm /home/" + (KD.nick()) + "/Web/" + this.webPrefix + "*");
  };

  return PreviewFinder;

})(KDView);
/* BLOCK STARTS: views/main.coffee */
var PreviewMainView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

PreviewMainView = (function(_super) {
  __extends(PreviewMainView, _super);

  function PreviewMainView(options, data) {
    var _this = this;
    if (options == null) {
      options = {};
    }
    PreviewMainView.__super__.constructor.call(this, options, data);
    KD.getSingleton("appManager").require("Teamwork", function() {
      _this.workspace = new Workspace({
        title: "Preview App",
        cssClass: "preview-app",
        name: "Preview App",
        panels: [
          {
            title: "Preview App",
            layout: {
              direction: "vertical",
              sizes: ["256px", null],
              splitName: "BaseSplit",
              views: [
                {
                  type: "custom",
                  name: "finder",
                  paneClass: PreviewFinder
                }, {
                  type: "custom",
                  name: "previewArea",
                  paneClass: PreviewArea
                }
              ]
            }
          }
        ]
      });
      _this.workspace.once("viewAppended", function() {
        _this.bindWorkspaceEvents();
        return _this.bindMenuEvents();
      });
      return KD.utils.defer(function() {
        return _this.addSubView(_this.workspace);
      });
    });
  }

  PreviewMainView.prototype.bindWorkspaceEvents = function() {
    var _ref;
    this.panel = this.workspace.getActivePanel();
    _ref = this.panel.panesByName, this.finder = _ref.finder, this.previewArea = _ref.previewArea;
    return this.previewArea.forwardEvent(this.panel, "FileSelected");
  };

  PreviewMainView.prototype.bindMenuEvents = function() {
    return this.on("toggleIconsMenuItemClicked", this.bound("toggleIcons"));
  };

  PreviewMainView.prototype.toggleIcons = function() {
    return this.finder.toggleClass("custom-icons");
  };

  return PreviewMainView;

})(KDView);
/* BLOCK STARTS: index.coffee */
var view;

if (typeof appView !== "undefined" && appView !== null) {
  view = new PreviewMainView;
  appView.addSubView(view);
} else {
  KD.registerAppClass(PreviewController, {
    name: "Preview",
    routes: {
      "/:name?/Umlgenerator": null,
      "/:name?/usirin/Apps/Preview": null
    },
    dockPath: "/usirin/Apps/Umlgenerator",
    behavior: "application",
    menu: {
      items: [
        {
          title: "Toggle Custom Icons",
          eventName: "toggleIcons"
        }
      ]
    }
  });
}

/* KDAPP ENDS */
}).call();