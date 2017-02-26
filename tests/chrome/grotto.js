module.exports = {
  'grottos' : function (browser) {
    browser
      .url('file://' + process.cwd() + '/gridmapper.svg')
      .assert.elementPresent('#exportarea')
      // because newlines in .keys('g\ngg\n gg\n  gg') didn't work
      .setValue('#exportarea', 'g\ngg\n gg\n  gg')
      // because .click('#import') didn't work
      .execute(function(data){
        window.textImport();
      }, [])
      .waitForElementPresent('#rock3_0_0', 1000)
      .assert.elementPresent('#rock2b_0_1')
      .assert.elementPresent('#rock2a_1_1')
      .assert.elementPresent('#rock2a_1_2')
      .assert.elementPresent('#rock2b_2_2')
      .assert.elementPresent('#rock2b_2_3')
      .assert.elementPresent('#rock3_3_3')
      .end();
  }
};

