module.exports = {
  'colors' : function (browser) {
    browser
      .url('file://' + process.cwd() + '/gridmapper.svg')
      .assert.elementPresent('#floor0')
      .keys('fG fG')
      .waitForElementPresent('#empty_0_0', 1000)
      .assert.elementPresent('#empty_1_0')
      .assert.attributeEquals('#empty_0_0', 'class', 'green')
      .assert.attributeEquals('#empty_1_0', 'class', 'green')
      .execute(function(data){
        window.Map.reset();
      }, [])
      .keys('gG gG gG')
      .waitForElementPresent('#rock3_0_0', 1000)
      .assert.attributeEquals('#rock3_0_0', 'class', 'green')
      .assert.attributeEquals('#rock3_0_0', 'rotate', '270')
      .assert.elementPresent('#rockd_1_0')
      .assert.attributeEquals('#rockd_1_0', 'class', 'green')
      .assert.attributeEquals('#rockd_1_0', 'rotate', '270')
      .assert.elementPresent('#rock3_2_0')
      .assert.attributeEquals('#rock3_2_0', 'class', 'green')
      .assert.attributeEquals('#rock3_2_0', 'rotate', '90')
      .execute(function(data){
        window.Map.reset();
      }, [])
      .keys('fB wfB wfB')
      .waitForElementPresent('#empty_0_0', 1000)
      .assert.attributeEquals('#empty_0_0', 'class', 'blue')
      .assert.attributeEquals('#empty_1_0', 'class', 'blue')
      .assert.attributeEquals('#empty_2_0', 'class', 'blue')
      .execute(function(data){
        window.Map.reset();
      }, [])
      .keys('fB dBfB dfB')
      .waitForElementPresent('#empty_0_0', 1000)
      .assert.attributeEquals('#empty_0_0', 'class', 'blue')
      .assert.attributeEquals('#empty_1_0', 'class', 'blue')
      .assert.attributeEquals('#empty_2_0', 'class', 'blue')
      .assert.attributeEquals('#door_1_0', 'rotate', '0')
      .assert.attributeEquals('#door_1_0', 'class', 'blue')
      .assert.attributeEquals('#door_2_0', 'rotate', '0')
      .getAttribute("#door_2_0", "class", function(result) {
        this.assert.strictEqual(result.value, null, 'class is null');
      })
      .execute(function(data){
        window.Map.reset();
      }, [])
      .keys('cR nR')
      .waitForElementPresent('#chest_0_0', 1000)
      .assert.attributeEquals('#chest_0_0', 'class', 'red')
      .assert.attributeEquals('#diagonal_1_0', 'class', 'red')
      .assert.attributeEquals('#diagonal_1_0', 'rotate', '0')
      .setValue("#exportarea", 'test')
      // this doesn't work for some reason
      // .click('#export')
      .execute(function(data){
        window.textExport();
      }, [])
      .assert.valueContains("#exportarea", 'cR nR')
      .end();
  }
};
