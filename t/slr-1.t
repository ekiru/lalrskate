#!/usr/bin/env winxed

function main[main]() {
    load_bytecode("rosella/test.pbc");
    load_bytecode("lalr.pbc");
    using Rosella.Test.test;
    test(class SLR1Test);
}

function g_1() {
    var grammar = new LALR.Grammar;
    grammar.add_terminal('{');
    grammar.add_terminal('}');
    grammar.add_terminal('i');
    grammar.add_terminal('^');
    grammar.add_terminal('+');

    grammar.add_nonterminal('E');
    grammar.add_nonterminal('T');
    grammar.add_nonterminal('P');

    grammar.start('E');

    grammar.add_rule('E', 'E', '+', 'T');
    grammar.add_rule('E', 'T');
    grammar.add_rule('T', 'P', '^', 'T');
    grammar.add_rule('T', 'P');
    grammar.add_rule('P', 'i');
    grammar.add_rule('P', '{', 'E', '}');

    return (new LALR.Generator).generate(grammar);
}

class StringActions {
    function terminal_action(terminal, match) {
	match.ast("(t " + string(terminal) + ")");
    }

    function nonterminal_action(name, number, match) {
	string children = "";
	for (var child in match.children()) {
	    children += " " + string(child.ast());
	}
	match.ast("(nt " + string(name) + " " + string(number) + children + ")");
    }
}

class SLR1Test {
    function test_g_1() {
	using LALR.DPDA.Interpreter.parse;
	var dpda = g_1();
	var actions = new StringActions;

	var interp = new LALR.DPDA.Interpreter;

	var match = parse(dpda, ["i", "+", "{", "i", "}", "^", "i"], actions:[named("actions")]);
	self.assert.equal("(nt E 0 (nt E 1 (nt T 1 (nt P 0 (t i)))) (t +) (nt T 0 (nt P 1 (t {) (nt E 1 (nt T 1 (nt P 0 (t i)))) (t })) (t ^) (nt T 1 (nt P 0 (t i)))))",
			  match.ast());
    }
}