module.exports = {
  'walls' : function (browser) {
    browser
      .url('file://' + process.cwd() + '/gridmapper.svg')
      .assert.elementPresent('g#walls0')
      .keys('w')
      .assert.elementPresent('#wall_0_0')
      .assert.attributeEquals('#wall_0_0', 'rotate', '0')
      .keys('w')
      .assert.attributeEquals('#wall_0_0', 'rotate', '90')
      // enter wall mode
      .keys('mw')
      .assert.attributeEquals('#wall_1_0', 'rotate', '0')
      // variant
      .keys('v')
      .assert.elementNotPresent('#wall_1_0')
      .assert.elementPresent('#curtain_1_0')
      .end();
  }
};
