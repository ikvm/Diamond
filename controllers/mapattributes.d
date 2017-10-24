/**
* Copyright © DiamondMVC 2016-2017
* License: MIT (https://github.com/DiamondMVC/Diamond/blob/master/LICENSE)
* Author: Jacob Jensen (bausshf)
*/
module diamond.controllers.mapattributes;

import diamond.core.apptype;

static if (isWeb)
{
  import vibe.d : HTTPMethod;

  /// Attribute for default http actions.
  struct HttpDefault {}

  /// Attribute for mandatory http actions.
  struct HttpMandatory {}

  /// Attribute for http actions.
  struct HttpAction
  {
    /// The http method of the action.
    HTTPMethod method;

    /// The name of the action. Equivalent to /route/{action}
    string action;
  }

  /// Attribute for authentication.
  struct HttpAuthentication
  {
    /// The class to use for authentcation. It must implement IControllerAuth.
    string authenticationClass;
  }

  /// Attribute for disabling authentication.
  struct HttpDisableAuth { }
}