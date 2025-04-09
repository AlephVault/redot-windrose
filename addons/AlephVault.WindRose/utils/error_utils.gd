extends Object

## This is some sort of exception or error code.
class Error:
	var _code: String

	## The code. Typically, a slug.
	var code: String:
		get:
			return _code
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"Error", "code"
			)
	
	var _detail: String

	## The detail. Typically, a readable string.
	var detail: String:
		get:
			return _detail
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"Error", "detail"
			)
	
	func _init(code: String, detail: String = ""):
		_code = code
		_detail = detail
	
	func raise():
		assert(false, self._detail)
		return self
