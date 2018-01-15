const webglHelper = () => {
  function initWebGlProgram(gl, vertexShaderSource, fragmentShaderSource) {
    const shaderProgram = initShaderProgram(
      gl,
      vertexShaderSource,
      fragmentShaderSource
    );

    return {
      program: shaderProgram,
      attribLocations: {
        vertexPosition: gl.getAttribLocation(shaderProgram, "aVertexPosition"),
        vertexColor: gl.getAttribLocation(shaderProgram, "aVertexColor")
      },
      uniformLocations: {
        projectionMatrix: gl.getUniformLocation(
          shaderProgram,
          "uProjectionMatrix"
        ),
        motionMatrix: gl.getUniformLocation(shaderProgram, "uMotionMatrix")
      }
    };
  }

  function initShaderProgram(gl, vertexShaderSource, fragmentShaderSource) {
    // Load shader source code
    const vertexShader = loadShader(gl, gl.VERTEX_SHADER, vertexShaderSource);
    const fragmentShader = loadShader(
      gl,
      gl.FRAGMENT_SHADER,
      fragmentShaderSource
    );

    // Create the shader program
    const shaderProgram = gl.createProgram();
    gl.attachShader(shaderProgram, vertexShader);
    gl.attachShader(shaderProgram, fragmentShader);
    gl.linkProgram(shaderProgram);

    // Check that program creation worked
    if (!gl.getProgramParameter(shaderProgram, gl.LINK_STATUS)) {
      const log = gl.getProgramInfoLog(shaderProgram);
      throw "Unable to initialize shader program: " + log;
    }

    return shaderProgram;
  }

  function loadShader(gl, type, source) {
    const shader = gl.createShader(type);
    gl.shaderSource(shader, source);
    gl.compileShader(shader);

    // Check that compilation worked
    if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
      const log = gl.getShaderInfoLog(shader);
      gl.deleteShader(shader);
      throw "An error occurred while compiling shader: " + log;
    }

    return shader;
  }

  function initBuffers(gl, positions, colors) {
    return {
      position: bindDataToBuffer(gl, positions),
      color: bindDataToBuffer(gl, colors)
    };
  }

  function bindDataToBuffer(gl, data) {
    const buffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
    gl.bufferData(gl.ARRAY_BUFFER, data, gl.STATIC_DRAW);
    return buffer;
  }

  function clearCanvas(gl) {
    gl.clearColor(0.0, 0.0, 0.0, 1.0); // Clear to black, fully opaque
    gl.clearDepth(1.0); // Clear everything
    gl.enable(gl.DEPTH_TEST); // Enable depth testing
    gl.depthFunc(gl.LEQUAL); // Near things obscure far ones
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT); // Clear canvas
  }

  function bindBufferToAttribute(gl, buffer, attributeIndex, size) {
    const type = gl.FLOAT;
    const normalize = false;
    const stride = 0;
    const offset = 0;
    gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
    gl.vertexAttribPointer(
      attributeIndex,
      size,
      type,
      normalize,
      stride,
      offset
    );
    gl.enableVertexAttribArray(attributeIndex);
  }

  return {
    initWebGlProgram: initWebGlProgram,
    initBuffers: initBuffers,
    clearCanvas: clearCanvas,
    bindBufferToAttribute: bindBufferToAttribute
  };
};
