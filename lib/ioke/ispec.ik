
ISpec = Origin mimic

use("ispec/conditions")
use("ispec/formatter")
use("ispec/reporter")
use("ispec/expectations")
use("ispec/extendedDefaultBehavior")
use("ispec/describeContext")
use("ispec/example")
use("ispec/runner")
use("ispec/mocking")
use("ispec/comparisonCompactor")

ISpec ispec_options = method(
  parser = ISpec Runner OptionParser create(System err, System out)
  parser order!(System programArguments)
  ISpec ispec_options = parser options)

DefaultBehavior mimic!(ISpec ExtendedDefaultBehavior)
