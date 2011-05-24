#!/usr/bin/env winxed --nowarn


function main[main]() {
    load_bytecode("rosella/test.pbc");
    load_bytecode("lalr.pbc");
    using Rosella.Test.test;
    test(class LALRGrammarTest);
}

class LALRGrammarTest {
    function test_creation() {
        using LALR.Grammar;
        var g = new LALR.Grammar;
        g.start("List");
        g.add_rule("List");
        g.add_rule("List", "Element", "List");
        g.add_rule("Element", "number");

        self.assert.equal("List", g.start());
        int len = g.rule("List")[0];
        self.assert.equal(0, len);
        len = g.rule("List")[1];
        self.assert.equal(2, len);
        self.assert.equal("Element", g.rule("List")[1][0]);
        self.assert.equal("List", g.rule("List")[1][1]);
        len = g.rule("Element")[0];
        self.assert.equal(1, len);
        self.assert.equal("number", g.rule("Element")[0][0]);
    }
}
