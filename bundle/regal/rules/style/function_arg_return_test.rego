package regal.rules.style_test

import future.keywords.if

import data.regal.ast
import data.regal.config
import data.regal.rules.style
import data.regal.rules.style.common_test.report

test_fail_function_arg_return_value if {
	r := report(`foo := i { indexof("foo", "o", i) }`)
	r == {{
		"category": "style",
		"description": "Function argument used for return value",
		"level": "error",
		"location": {"col": 32, "file": "policy.rego", "row": 8, "text": "foo := i { indexof(\"foo\", \"o\", i) }"},
		"related_resources": [{
			"description": "documentation",
			"ref": config.docs.resolve_url("$baseUrl/$category/function-arg-return", "style"),
		}],
		"title": "function-arg-return",
	}}
}

test_success_function_arg_return_value_except_function if {
	r := style.report with input as ast.with_future_keywords(`foo := i { indexof("foo", "o", i) }`)
		with config.for_rule as {
			"level": "error",
			"except-functions": ["indexof"],
		}
	r == set()
}
