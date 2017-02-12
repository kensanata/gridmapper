module.exports = {
  'Setup Help Screen' : function (browser) {
    browser
      .url('file://' + process.cwd() + '/gridmapper.svg')
      .waitForElementVisible('g#help', 1000)
      // .setValue('input[type=text]', 'nightwatch')
      // .waitForElementVisible('button[name=btnG]', 1000)
      // .click('button[name=btnG]')
      // .pause(1000)              
      .assert.containsText('#help', 'Alex Schroeder')
      .end();
  }
};
