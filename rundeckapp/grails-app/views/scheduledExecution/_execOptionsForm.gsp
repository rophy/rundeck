%{--
  - Copyright 2016 SimplifyOps, Inc. (http://simplifyops.com)
  -
  - Licensed under the Apache License, Version 2.0 (the "License");
  - you may not use this file except in compliance with the License.
  - You may obtain a copy of the License at
  -
  -     http://www.apache.org/licenses/LICENSE-2.0
  -
  - Unless required by applicable law or agreed to in writing, software
  - distributed under the License is distributed on an "AS IS" BASIS,
  - WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  - See the License for the specific language governing permissions and
  - limitations under the License.
  --}%

<div class="row">
<div class="col-sm-12 ">

<g:form controller="scheduledExecution" method="post" useToken="true"
        params="[project:scheduledExecution.project]" class="form-horizontal" role="form">
    <!-- BEGIN: firefox hack https://bugzilla.mozilla.org/show_bug.cgi?id=1119063 -->
    <input type="text" style="display:none" class="ixnay">
    <input type="password" style="display:none" class="ixnay">
    <g:javascript>
    jQuery(function(){
        var nay=function(){jQuery('.ixnay').val('');},ix=setTimeout;
        nay(); ix(nay,50); ix(nay,200); ix(nay, 1000);
    });
    </g:javascript>
    <!-- END: firefox hack -->

<input id='runAtTime' type='hidden' name='runAtTime' value='' />

<div class="panel panel-default panel-tab-content panel-modal-content">
<g:if test="${!hideHead}">
    <div class="panel-heading">
        <div class="row">
            <tmpl:showHead scheduledExecution="${scheduledExecution}" iconName="icon-job"
                           runPage="true" jobDescriptionMode="collapsed"/>
        </div>
    </div>
</g:if>
<div class="list-group list-group-tab-content">
<div class="list-group-item">
<div class="row">
<div class="${hideHead?'col-sm-9':'col-sm-12'}">
    <g:render template="editOptions" model="${[scheduledExecution:scheduledExecution, selectedoptsmap:selectedoptsmap, selectedargstring:selectedargstring,authorized:authorized,jobexecOptionErrors:jobexecOptionErrors, optiondependencies: optiondependencies, dependentoptions: dependentoptions, optionordering: optionordering]}"/>
    <div class="form-group" style="${wdgt.styleVisible(if: nodesetvariables && !failedNodes || nodesetempty || nodes)}">
    <div class="col-sm-2 control-label text-form-label">
        <g:message code="Node.plural" />
    </div>
    <div class="col-sm-10">
        <g:if test="${nodesetvariables && !failedNodes}">
            %{--show node filters--}%
            <div>
                <span class="query form-control-static ">
                   <span class="queryvalue text"><g:enc>${nodefilter}</g:enc></span>
                </span>
            </div>

            <p class="form-control-static text-info">
                <g:message code="scheduledExecution.nodeset.variable.warning"/>
            </p>
        </g:if>
        <g:elseif test="${nodesetempty }">
            <div class="alert alert-warning">
                <g:message code="scheduledExecution.nodeset.empty.warning"/>
            </div>
        </g:elseif>
        <g:elseif test="${nodes}">
            <g:set var="selectedNodes"
                   value="${failedNodes? failedNodes.split(','):selectedNodes!=null? selectedNodes.length()>0? selectedNodes.split(','):false :null}"/>
            <div class="container">
            <div class="row">
                <div class="col-sm-12 checkbox">
                    <label >
                    <input name="extra._replaceNodeFilters" value="${selectedNodes!=null?'true':'false'}" type="hidden" id="doReplaceFiltersActual"/>
                    <input type="checkbox"
                           data-toggle="collapse"
                           data-target="#nodeSelect"
                        ${selectedNodes!=null?'checked disabled':''}
                           id="doReplaceFilters"/>
                    Change the Target Nodes
                (<span class="nodeselectcount"><g:enc>${selectedNodes?selectedNodes.size():selectedNodes==false?0:nodes.size()}</g:enc></span>)</label>
                </div>

            </div>
            </div>
            <div class=" matchednodes embed jobmatchednodes group_section collapse ${selectedNodes!=null? 'in' : ''}" id="nodeSelect">
                    <div class=" group_select_control" style="${wdgt.styleVisible(if: selectedNodes != null)}">
                        Select:
                        <span class="textbtn textbtn-default textbtn-on-hover selectall">All</span>
                        <span class="textbtn textbtn-default textbtn-on-hover selectnone">None</span>
                        <g:if test="${tagsummary}">
                            <g:render template="/framework/tagsummary"
                                      model="${[tagsummary:tagsummary,action:[classnames:'tag active textbtn obs_tag_group',onclick:'']]}"/>
                        </g:if>
                    </div>
		    <select multiple="multiple" name="extra.nodeIncludeName">
			<g:each var="node" in="${nodes}" status="index">
				<g:set var="nkey" value="${g.rkey()}"/>
				<option
					id="${enc(attr:nkey)}"
					value="${enc(attr:node.nodename)}"
					 ${selectedNodes == null ? 'selected' : selectedNodes == false ? '' : selectedNodes.contains(node.nodename) ? 'selected' : ''}
					data-tag="${enc(attr:node.tags?.join(' '))}">
                                        ${enc(attr:node.nodename)}
                                </option>
			</g:each>
		    </select>
            </div>
            <g:javascript>
                var nodeLength = jQuery('select[name="extra.nodeIncludeName"]').get(0).options.length;
                var selectorHeight = nodeLength / 2;
                if (selectorHeight < 100) {
                    selectorHeight = 100;
                }
                if (selectorHeight > 480) {
                    selectorHeight = 480;
                }
                jQuery('select[name="extra.nodeIncludeName"]').bootstrapDualListbox({
                    nonSelectedListLabel:'Available',
                    selectedListLabel:'Selected',
                    moveOnSelect:false,
                    selectorMinimalHeight: selectorHeight
                });
                var updateSelectCount = function (evt) {
                    var selected = jQuery('select[name="extra.nodeIncludeName"] option:checked');
                    var count = selected ? selected.length : 0;
                    $$('.nodeselectcount').each(function (e2) {
                        setText($(e2), count + '');
                        $(e2).removeClassName('text-info');
                        $(e2).removeClassName('text-danger');
                        $(e2).addClassName(count>0?'text-info':'text-danger');
                    });
                };
                $$('select[name="extra.nodeIncludeName_helper1"]').each(function(e) {
                    Event.observe(e, 'change', function(evt) {
                      Event.fire($('nodeSelect'), 'nodeset:change');
                    });
                });
                $$('select[name="extra.nodeIncludeName_helper2"]').each(function(e) {
                    Event.observe(e, 'change', function(evt) {
                      Event.fire($('nodeSelect'), 'nodeset:change');
                    });
                });
                $$('.bootstrap-duallistbox-container .btn').each(function(e) {
                    Event.observe(e, 'click', function(evt) {
                      Event.fire($('nodeSelect'), 'nodeset:change');
                    });
                });
                Event.observe($('nodeSelect'), 'nodeset:change', updateSelectCount);
                $$('div.jobmatchednodes span.textbtn.selectall').each(function (e) {
                    Event.observe(e, 'click', function (evt) {
                        $(e).up('.group_section').select('select[name="extra.nodeIncludeName"] option').each(function (el) {
                            el.selected = true;
                        });
                        $(e).up('.group_section').select('span.textbtn.obs_tag_group').each(function (e) {
                            $(e).setAttribute('data-tagselected', 'true');
                            $(e).addClassName('active');
                        });
                        jQuery('select[name="extra.nodeIncludeName"]').bootstrapDualListbox('refresh', true);
                        Event.fire($('nodeSelect'), 'nodeset:change');
                    });
                });
                $$('div.jobmatchednodes span.textbtn.selectnone').each(function (e) {
                    Event.observe(e, 'click', function (evt) {
                        $(e).up('.group_section').select('select[name="extra.nodeIncludeName"] option').each(function (el) {
                            el.selected = false;
                        });
                        $(e).up('.group_section').select('span.textbtn.obs_tag_group').each(function (e) {
                            $(e).setAttribute('data-tagselected', 'false');
                            $(e).removeClassName('active');
                        });
                        jQuery('select[name="extra.nodeIncludeName"]').bootstrapDualListbox('refresh', true);
                        Event.fire($('nodeSelect'), 'nodeset:change');
                    });
                });
                $$('div.jobmatchednodes span.textbtn.obs_tag_group').each(function (e) {
                    Event.observe(e, 'click', function (evt) {
                        var ischecked = e.getAttribute('data-tagselected') != 'false';
                        e.setAttribute('data-tagselected', ischecked ? 'false' : 'true');
                        if (!ischecked) {
                            $(e).addClassName('active');
                        } else {
                            $(e).removeClassName('active');
                        }
                        $(e).up('.group_section').select('select[name="extra.nodeIncludeName"] option[data-tag~="' + e.getAttribute('data-tag') + '"]').each(function (el) {
                            el.selected = !ischecked;
                        });
                        $(e).up('.group_section').select('span.textbtn.obs_tag_group[data-tag="' + e.getAttribute('data-tag') + '"]').each(function (el) {
                            el.setAttribute('data-tagselected', ischecked ? 'false' : 'true');
                            if (!ischecked) {
                                $(el).addClassName('active');
                            } else {
                                $(el).removeClassName('active');
                            }
                        });
                        jQuery('select[name="extra.nodeIncludeName"]').bootstrapDualListbox('refresh', true);
                        Event.fire($('nodeSelect'), 'nodeset:change');
                    });
                });

                Event.observe($('doReplaceFilters'), 'change', function (evt) {
                    var e = evt.element();
                    $$('#doReplaceFiltersActual').each(function(cb) {
                        cb.value = e.checked ? 'true' : 'false';
                    });
                    $$('select[name="extra.nodeIncludeName"] option').each(function (cb) {
                        // [cb].each(e.checked ? Field.enable : Field.disable);
                        if (!e.checked) {
                            $$('.group_select_control').each(Element.hide);
                        } else {
                            $$('.group_select_control').each(Element.show);
                        }
                    });
                    jQuery('select[name="extra.nodeIncludeName"]').bootstrapDualListbox('refresh', true);
                    Event.fire($('nodeSelect'), 'nodeset:change');
                    if(!e.checked){
                        $$('.nodeselectcount').each(function (e2) {
                            $(e2).removeClassName('text-info');
                            $(e2).removeClassName('text-danger');
                        });
                    }
                    // Once checked, do not allow user to uncheck, to prevent confusion
                    if (e.checked) {
                        e.disabled = true;
                    }
                });


                /** reset focus on click, so that IE triggers onchange event*/
                Event.observe($('doReplaceFilters'), 'click', function (evt) {
                    this.blur();
                    this.focus();
                });

            </g:javascript>
            <g:if test="${scheduledExecution.hasNodesSelectedByDefault()}">
                <g:javascript>
                    Event.fire($('nodeSelect'), 'nodeset:change');
                </g:javascript>
            </g:if>
        </g:elseif>
    </div>
    </div>

    <div class="error note" id="formerror" style="display:none">

    </div>
</div>
<g:if test="${hideHead}">
<div class="col-sm-3">
    <div id="formbuttons">
        <g:if test="${!hideCancel}">
            <g:actionSubmit id="execFormCancelButton" value="Cancel" class="btn btn-default"/>
        </g:if>
        <div class="pull-right">
            <div title="${scheduledExecution.hasExecutionEnabled() ? '':g.message(code: 'disabled.job.run')}"
                  class="has_tooltip"
                  data-toggle="tooltip"
                  data-placement="auto right"
            >%{--Extra div because attr disabled will cancel tooltip from showing --}%
                <button type="submit"
                        name="_action_runJobNow"
                        id="execFormRunButton"
                        ${scheduledExecution.hasExecutionEnabled() ? '':'disabled' }
                        class=" btn btn-success">
                    <g:message code="run.job.now" />
                    <b class="glyphicon glyphicon-play"></b>
                </button>
                <a tabindex="0" role="button"
                        id="showScheduler"
                        ${scheduledExecution.hasExecutionEnabled() ? '':'disabled' }
                        class=" btn btn-default"
                        data-toggle="popover" title="Set start time" data-trigger="click"
                        data-placement="auto left" data-container="body" data-html="true"
                        data-trigger="focus" data-content="<div id='scheduler'>
                                <div class='input-group date' id='datetimepicker'>
                                    <input type='text' class='form-control' />
                                    <span class='input-group-addon'>
                                        <span class='glyphicon glyphicon-calendar'></span>
                                    </span>
                                </div>
                                <div id='dateAlert' class='alert alert-warning alert-block fade' style='display: none'>
                                    ${message(code:"the.time.must.be.in.the.future")}
                                </div>
                                <button type='submit'
                                        id='scheduleSubmitButton'
                                        name='_action_runJobLater'
                                        class=' btn btn-success schedule-button'>
                                    ${message(code:'schedule.job')}
                                    <b class='glyphicon glyphicon-time'></b>
                                </button>
                            </div>">
                    <g:message code="run.job.later" />
                    <b class="glyphicon glyphicon-time"></b>
                </a>
            </div>
        </div>
        <div class="clearfix">
        </div>
        <div class="pull-right">
            <label class="control-label">
                <g:checkBox id="followoutputcheck" name="follow"
                            checked="${defaultFollow || params.follow == 'true'}"
                            value="true"/>
                <g:message code="job.run.watch.output"/>
            </label>
        </div>
    </div>
</div>
</g:if>
</div>
</div>
</div>
<g:if test="${!hideHead}">
<div class="panel-footer">
    <div class="row" >
        <div class="col-sm-12 form-inline" id="formbuttons">
            <g:if test="${!hideCancel}">
                <g:actionSubmit id="execFormCancelButton" value="Cancel" class="btn btn-default"/>
            </g:if>
            <div title="${scheduledExecution.hasExecutionEnabled() ? '':g.message(code: 'disabled.job.run')}"
                  class="form-group has_tooltip"
                  data-toggle="tooltip"
                  data-placement="auto right"
            >%{--Extra div because attr disabled will cancel tooltip from showing --}%
                <button type="submit"
                        name="_action_runJobNow"
                        id="execFormRunButton"
                        ${scheduledExecution.hasExecutionEnabled() ? '':'disabled' }
                        class=" btn btn-success">
                    <i class="glyphicon glyphicon-play"></i>
                    <g:message code="run.job.now" />
                </button>
                <a tabindex="0" role="button"
                        id="showScheduler"
                        ${scheduledExecution.hasExecutionEnabled() ? '':'disabled' }
                        class=" btn btn-default"
                        data-toggle="popover" title="Set start time" data-trigger="click"
                        data-placement="auto bottom" data-container="#formbuttons" data-html="true"
                        data-trigger="focus" data-content="<div id='scheduler'>
                                <div class='input-group date' id='datetimepicker'>
                                    <input type='text' class='form-control' />
                                    <span class='input-group-addon'>
                                        <span class='glyphicon glyphicon-calendar'></span>
                                    </span>
                                </div>
                                <div id='dateAlert' class='alert alert-warning alert-block fade' style='display: none'>
                                    ${message(code:"the.time.must.be.in.the.future")}
                                </div>
                                <button type='submit'
                                        id='scheduleAjaxButton'
                                        class=' btn btn-success schedule-button'>
                                    <i class='glyphicon glyphicon-time'></i>
                                    ${message(code:'schedule.job')}
                                </button>
                            </div>">
                    <i class="glyphicon glyphicon-time"></i>
                    <g:message code="run.job.later" />
                </a>

            </div>
            <div class="checkbox-inline">
                <label>
                    <g:checkBox id="followoutputcheck"
                                name="follow"
                                checked="${defaultFollow || params.follow == 'true'}"
                                value="true"/>
                    <g:message code="job.run.watch.output"/>
                </label>
            </div>
        </div>
    </div>
</div>
</g:if>
</div>%{--/.panel--}%
</g:form>
</div> %{--/.col--}%
</div> %{--/.row--}%

<content tag="footScripts">
    <asset:stylesheet src="bootstrap-datetimepicker.min.css" />
    <asset:javascript src="scheduler.js" />
</content tag="footScripts">

<asset:stylesheet src="bootstrap-datetimepicker.min.css" />
<asset:javascript src="scheduler.js" />
