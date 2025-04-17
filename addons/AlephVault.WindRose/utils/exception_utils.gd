extends Object

## This is some sort of exception or error code.
class Exception:
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
	
	## Throws this error as assert message.
	func throw() -> Exception:
		assert(false, self._detail)
		return self
	
	## Creates and throws a new error.
	static func raise(code: String, detail: String = "") -> Exception:
		return new(code, detail).throw()

## This is a response, which may contain an
## error or a return value.
class Response:
	var _error: Exception

	## The exception of the response.
	var error: Exception:
		get:
			return _error
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"Response", "error"
			)

	var _value
	
	## The value of the response.
	var value:
		get:
			return _value
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"Response", "value"
			)
	
	func _init(error: Exception, value):
		_error = error
		_value = value
	
	## Tells whether the response is successful or not.
	func is_successful() -> bool:
		return _error == null
	
	## Creates a successful response.
	static func succeed(value) -> Response:
		return Response.new(null, value)
	
	## Creates a failed response.
	static func fail(error: Exception) -> Response:
		return Response.new(error, null)
