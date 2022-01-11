package armo_builtins


# Fails if pod doas not have container with livenessProbe
deny[msga] {
    pod := input[_]
    pod.kind == "Pod"
    container := pod.spec.containers[i]
	not container.livenessProbe
	path := sprintf("spec.containers[%v]", [format_int(i, 10)])
	msga := {
		"alertMessage": sprintf("Container: %v does not have livenessProbe", [ container.name]),
		"packagename": "armo_builtins",
		"alertScore": 4,
		"failedPaths": [path],
		"alertObject": {
			"k8sApiObjects": [pod]
		}
	}
}

# Fails if workload doas not have container with livenessProbe
deny[msga] {
    wl := input[_]
	spec_template_spec_patterns := {"Deployment","ReplicaSet","DaemonSet","StatefulSet","Job"}
	spec_template_spec_patterns[wl.kind]
    container := wl.spec.template.spec.containers[i]
    not container.livenessProbe
	path := sprintf("spec.template.spec.containers[%v]", [format_int(i, 10)])
	msga := {
		"alertMessage": sprintf("Container: %v in %v: %v   does not have livenessProbe", [ container.name, wl.kind, wl.metadata.name]),
		"packagename": "armo_builtins",
		"alertScore": 4,
		"failedPaths": [path],
		"alertObject": {
			"k8sApiObjects": [wl]
		}
	}
}

# Fails if cronjob doas not have container with livenessProbe
deny[msga] {
  	wl := input[_]
	wl.kind == "CronJob"
	container = wl.spec.jobTemplate.spec.template.spec.containers[i]
    not container.livenessProbe
	path := sprintf("spec.jobTemplate.spec.template.spec.containers[%v]", [format_int(i, 10)])
    msga := {
		"alertMessage": sprintf("Container: %v in %v: %v   does not have livenessProbe", [ container.name, wl.kind, wl.metadata.name]),
		"packagename": "armo_builtins",
		"alertScore": 4,
		"failedPaths": [path],
		"alertObject": {
			"k8sApiObjects": [wl]
		}
	}
}
