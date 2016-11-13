/*
 * Copyright 2016 SimplifyOps, Inc. (http://simplifyops.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.rundeck.plugin.example;

import java.util.Collection;

import com.dtolabs.rundeck.core.common.INodeEntry;
import com.dtolabs.rundeck.core.execution.workflow.StepExecutionContext;
import com.dtolabs.rundeck.core.plugins.Plugin;
import com.dtolabs.rundeck.plugins.ServiceNameConstants;
import com.dtolabs.rundeck.plugins.descriptions.PluginDescription;
import com.dtolabs.rundeck.plugins.descriptions.PluginProperty;
import com.dtolabs.rundeck.plugins.orchestrator.Orchestrator;
import com.dtolabs.rundeck.plugins.orchestrator.OrchestratorPlugin;

@Plugin(name = "maxPercentage", service = ServiceNameConstants.Orchestrator)
@PluginDescription(title = "Max Percentage",
                   description = "Will never process more than the given percentage of nodes per run at one time " +
                                 "regardless of how high threads are configured")
public class MaxPercentageOrchestatorPlugin implements OrchestratorPlugin {


    @PluginProperty(title = "Percent", description = "Max Percentage", defaultValue = "33")
    protected int percent;

    @Override
    public Orchestrator createOrchestrator(StepExecutionContext context, Collection<INodeEntry> nodes) {
        return new MaxPercentageOrchestator(context, nodes, percent);
    }

}
