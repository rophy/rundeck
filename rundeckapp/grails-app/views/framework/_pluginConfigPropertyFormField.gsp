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
 <%--
    _pluginConfigProperty.gsp
    
    Author: Greg Schueler <a href="mailto:greg@dtosolutions.com">greg@dtosolutions.com</a>
    Created: 7/28/11 12:01 PM
 --%>

<%@ page import="com.dtolabs.rundeck.core.plugins.configuration.PropertyScope; com.dtolabs.rundeck.plugins.ServiceNameConstants; com.dtolabs.rundeck.core.plugins.configuration.StringRenderingConstants" contentType="text/html;charset=UTF-8" %>
%{--<g:set var="fieldname" value="${}"/>--}%
%{--<g:set var="origfieldname" value="${}"/>--}%
<g:set var="labelColType" value="col-sm-2 control-label input-sm"/>
<g:set var="valueColType" value="col-sm-10"/>
<g:set var="valueColTypeSplitA" value="col-sm-5"/>
<g:set var="valueColTypeSplitB" value="col-sm-5"/>
<g:set var="valueColTypeSplit80" value="col-sm-8"/>
<g:set var="valueColTypeSplit20" value="col-sm-2"/>
<g:set var="offsetColType" value="col-sm-10 col-sm-offset-2"/>
<g:set var="formControlType" value="form-control input-sm"/>
<g:set var="formControlCodeType" value="form-control code apply_ace"/>
<g:set var="hasError" value="${error ? 'has-error' : ''}"/>
<g:set var="required" value="${prop.required ? 'required' : ''}"/>
<g:set var="propScope"
       value="${prop.scope != null && prop.scope != PropertyScope.Unspecified ? prop.scope : defaultScope}"/>
<g:unless test="${outofscopeOnly && propScope?.isInstanceLevel()}">
<div class="form-group ${enc(attr:hasError)}">

<g:if test="${outofscope}">
    <label class="${labelColType} form-control-static ${error?'has-error':''}  ${prop.required ? 'required' : ''}">
        <stepplugin:message
                service="${service}"
                name="${provider}"
                code="${messagePrefix}property.${prop.name}.title"
                default="${prop.title ?: prop.name}"/>:
    </label>
</g:if>
<g:elseif test="${prop.type.toString()=='Boolean'}">
    <g:set var="fieldid" value="${g.rkey()}"/>
    <div class="${offsetColType}">
        <g:hiddenField name="${origfieldname}" value="${values && values[prop.name] ? values[prop.name] : ''}"/>
        <div class="checkbox">
            <label
                   for="${enc(attr:fieldid)}">
                <g:checkBox name="${fieldname}" value="true"
                            checked="${values&&values[prop.name]?values[prop.name]=='true':prop.defaultValue=='true'}"
                            id="${fieldid}"/>
                <stepplugin:message
                        service="${service}"
                        name="${provider}"
                        code="${messagePrefix}property.${prop.name}.title"
                        default="${prop.title ?: prop.name}"/>
            </label>
        </div>
    </div>
</g:elseif>
<g:elseif test="${prop.type.toString()=='Select' || prop.type.toString()=='FreeSelect'}">
    <g:set var="fieldid" value="${g.rkey()}"/>
    <label class="${labelColType}   ${prop.required ? 'required' : ''}"
           for="${enc(attr: fieldid)}"><stepplugin:message
            service="${service}"
            name="${provider}"
            code="${messagePrefix}property.${prop.name}.title"
            default="${prop.title ?: prop.name}"/></label>

    <g:hiddenField name="${origfieldname}" value="${values&&values[prop.name]?values[prop.name]:''}"/>
    <g:if test="${prop.type.toString()=='FreeSelect'}">
        <div class="${valueColTypeSplitA}">
        <g:textField name="${fieldname}" value="${values&&null!=values[prop.name]?values[prop.name]:prop.defaultValue}"
                     id="${fieldid}" size="100" class="${formControlType} ${extraInputCss}"/>
        </div>
        <div class="${valueColTypeSplitB}">
        <g:set var="propSelectValues" value="${prop.selectValues.collect{[key:it.encodeAsHTML(),value:it]}}"/>
        <g:select name="${fieldid+'_sel'}" from="${propSelectValues}" id="${fieldid}"
                    optionKey="key" optionValue="value"
                  value="${(values&&null!=values[prop.name]?values[prop.name]:prop.defaultValue)?.encodeAsHTML()}"
                  noSelection="['':'-choose a value-']"
            onchange="if(this.value){\$('${fieldid}').value=this.value;}"
            class="${formControlType}"
        />
        </div>
    </g:if>
    <g:else>
        <g:set var="propSelectValues" value="${prop.selectValues.collect{[key:it.encodeAsHTML(),value:it]}}"/>
        <g:set var="noSelectionValue" value="${prop.required ? null : ['':'-none selected-']}"/>
        <div class="${valueColType}">
        <g:select name="${fieldname}" from="${propSelectValues}" id="${fieldid}"
                  optionKey="key" optionValue="value"
                  noSelection="${ noSelectionValue }"
                  value="${(values&&null!=values[prop.name]?values[prop.name]:prop.defaultValue)?.encodeAsHTML()}"
                  class="${formControlType}"/>
        </div>
    </g:else>
</g:elseif>
<g:else>
    <g:set var="fieldid" value="${g.rkey()}"/>
    <g:set var="hasStorageSelector" value="${prop.renderingOptions?.(StringRenderingConstants.SELECTION_ACCESSOR_KEY) in [StringRenderingConstants.SelectionAccessor.STORAGE_PATH,'STORAGE_PATH']}"/>
    <label class="${labelColType}  ${prop.required?'required':''}"
           for="${enc(attr: fieldid)}"><stepplugin:message
            service="${service}"
            name="${provider}"
            code="${messagePrefix}property.${prop.name}.title"
            default="${prop.title ?: prop.name}"/></label>
    <div class="${hasStorageSelector? valueColTypeSplit80: valueColType}">
    <g:hiddenField name="${origfieldname}" value="${values&&values[prop.name]?values[prop.name]:''}"/>
    <g:set var="valueText" value="${values&&null!=values[prop.name]?values[prop.name]:prop.defaultValue}"/>
    <g:if test="${prop.renderingOptions?.(StringRenderingConstants.DISPLAY_TYPE_KEY) in [StringRenderingConstants.DisplayType.MULTI_LINE, 'MULTI_LINE']}">
        <g:textArea name="${fieldname}" value="${valueText}"
                    id="${fieldid}" rows="10" cols="100" class="${formControlType}"/>
    </g:if>
    <g:elseif test="${prop.renderingOptions?.(StringRenderingConstants.DISPLAY_TYPE_KEY) in [StringRenderingConstants.DisplayType.CODE, 'CODE']}">
        <g:set var="syntax" value="${prop.renderingOptions?.(StringRenderingConstants.CODE_SYNTAX_MODE)}"/>
        <g:set var="syntaxSelectable" value="${prop.renderingOptions?.(StringRenderingConstants.CODE_SYNTAX_SELECTABLE)}"/>
        <g:textArea name="${fieldname}" value="${valueText}"
            data-ace-session-mode="${syntax}"
            data-ace-control-syntax="${syntaxSelectable?true:false}"
                    id="${fieldid}" rows="10" cols="100" class="${formControlCodeType} ${extraInputCss}"/>
    </g:elseif>
    <g:elseif test="${prop.renderingOptions?.(StringRenderingConstants.DISPLAY_TYPE_KEY) in [StringRenderingConstants.DisplayType.PASSWORD, 'PASSWORD']}">
       <g:passwordField name="${fieldname}" value="${valueText}"
                        autocomplete="new-password"
                    id="${fieldid}" cols="100" class="${formControlType}"/>
    </g:elseif>
    <g:elseif test="${prop.renderingOptions?.(StringRenderingConstants.DISPLAY_TYPE_KEY) in [StringRenderingConstants.DisplayType.STATIC_TEXT, 'STATIC_TEXT']}">
        %{--display value/defaultValue as static text in some format--}%
        %{--text/html--}%
        <g:set var="staticTextValue" value="${
                    stepplugin.messageText(
                            service: service,
                            name: provider,
                            code: 'property.' + prop.name + '.defaultValue',
                            default: prop.defaultValue
                    )
        }"/>
        <g:if test="${prop.renderingOptions?.(StringRenderingConstants.STATIC_TEXT_CONTENT_TYPE_KEY) in ['text/html']}">
           <g:enc sanitize="${staticTextValue}"/>
        </g:if>
        <g:elseif test="${prop.renderingOptions?.(StringRenderingConstants.STATIC_TEXT_CONTENT_TYPE_KEY) in ['text/x-markdown']}">
            %{--markdown--}%
            <g:markdown>${staticTextValue}</g:markdown>
        </g:elseif>
        <g:else>
            %{--plain--}%
            <g:enc html="${staticTextValue}"/>
        </g:else>
    </g:elseif>
    <g:else>
        <g:textField name="${fieldname}" value="${valueText}"
                 id="${fieldid}" size="100" class="${formControlType} ${extraInputCss}"/>
    </g:else>
    </div>
    <g:if test="${hasStorageSelector}">
        <div class="${valueColTypeSplit20}">
        %{-- selector for accessible storage --}%
        <g:set var="storageRoot" value="${prop.renderingOptions?.(StringRenderingConstants.STORAGE_PATH_ROOT_KEY)?:'/'}"/>
        <g:set var="storageFilter" value="${prop.renderingOptions?.(StringRenderingConstants.STORAGE_FILE_META_FILTER_KEY)?:''}"/>
        <a class="btn btn-sm btn-default obs-select-storage-path"
                data-toggle="modal"
                href="#storagebrowse"
                data-storage-root="${enc(attr:storageRoot)}"
                data-storage-filter="${enc(attr:storageFilter)}"
                data-field="#${enc(attr:fieldid)}"
        ><g:message code="select" /> <i class="glyphicon glyphicon-folder-open"></i></a>
        </div>
    </g:if>
</g:else>
<div class="${outofscope?valueColType:offsetColType}">
    <div class="help-block"> <g:render template="/scheduledExecution/description"
                                       model="[description: stepplugin.messageText(
                                               service: service,
                                               name: provider,
                                               code: 'property.' + prop.name + '.description',
                                               default: prop.description
                                       ), , textCss       : '',
                                               mode       : 'collapsed', rkey: g.rkey()]"/></div>
    <g:if test="${error}">
        <div class="text-warning"><g:enc>${error}</g:enc></div>
    </g:if>
    <g:if test="${outofscope}">
        <g:render template="/framework/pluginConfigPropertyScopeInfo" model="[prefix:prefix,specialConfiguration:specialConfiguration,propScope:propScope,mapping:mapping, frameworkMapping: frameworkMapping, hideMissingFrameworkMapping: hideMissingFrameworkMapping]"/>
    </g:if>
</div>
</div>
</g:unless>
