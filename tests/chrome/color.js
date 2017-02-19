module.exports = {
  'colors' : function (browser) {
    browser
      .url('file://' + process.cwd() + '/gridmapper.svg')
      .assert.elementPresent('#floor0')
      .keys('fG fG')
      .screenshot(true, null)
      .waitForElementPresent('#empty_0_0', 1000)
      .assert.elementPresent('#empty_1_0')
      .assert.attributeEquals('#empty_0_0', 'class', 'green')
      .assert.attributeEquals('#empty_1_0', 'class', 'green')
      .end();
  },
  'grotto' : function (browser) {
    browser
      .url('file://' + process.cwd() + '/gridmapper.svg')
      .assert.elementPresent('#floor0')
      .keys('gG gG gG')
      .screenshot(true, null)
      .waitForElementPresent('#rock3_0_0', 1000)
      .assert.attributeEquals('#rock3_0_0', 'class', 'green')
      .assert.attributeEquals('#rock3_0_0', 'rotate', '270')
      .assert.elementPresent('#rockd_1_0')
      .assert.attributeEquals('#rockd_1_0', 'class', 'green')
      .assert.attributeEquals('#rockd_1_0', 'rotate', '270')
      .assert.elementPresent('#rock3_2_0')
      .assert.attributeEquals('#rock3_2_0', 'class', 'green')
      .assert.attributeEquals('#rock3_2_0', 'rotate', '90')
      .end();
  }
};
