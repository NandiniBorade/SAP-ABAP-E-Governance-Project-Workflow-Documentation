REPORT zeg_week5_project_workflow.

*---------------------------------------------------------------------*
* E-GOVERNANCE FINAL PROJECT WORKFLOW
* WEEK 5 - PROJECT DOCUMENTATION AND WORKFLOW DESIGN
*---------------------------------------------------------------------*

TYPES: BEGIN OF ty_workflow,
         step_no       TYPE char5,
         module        TYPE char40,
         activity      TYPE char60,
         input_data    TYPE char80,
         output_data   TYPE char80,
         status        TYPE char15,
         remarks       TYPE char100,
       END OF ty_workflow.

DATA: gt_workflow TYPE STANDARD TABLE OF ty_workflow,
      gs_workflow TYPE ty_workflow.

DATA: gv_completed TYPE i,
      gv_pending   TYPE i.

DATA: gv_application_status TYPE char20,
      gv_document_status    TYPE char20,
      gv_certificate_status TYPE char20.

START-OF-SELECTION.

  PERFORM initialize_status.
  PERFORM validate_workflow.

  PERFORM citizen_registration.
  PERFORM application_creation.
  PERFORM document_verification.
  PERFORM application_processing.
  PERFORM certificate_processing.
  PERFORM update_application_status.
  PERFORM prepare_final_summary.

  PERFORM display_workflow.
  PERFORM display_summary.

*---------------------------------------------------------------------*
* INITIAL STATUS
*---------------------------------------------------------------------*
FORM initialize_status.

  gv_application_status = 'CREATED'.
  gv_document_status    = 'PENDING'.
  gv_certificate_status = 'PENDING'.

ENDFORM.

*---------------------------------------------------------------------*
* WORKFLOW VALIDATION
*---------------------------------------------------------------------*
FORM validate_workflow.

  IF gv_application_status IS INITIAL.
    MESSAGE 'Application status is missing' TYPE 'E'.
  ENDIF.

  IF gv_document_status IS INITIAL.
    MESSAGE 'Document status is missing' TYPE 'E'.
  ENDIF.

  IF gv_certificate_status IS INITIAL.
    MESSAGE 'Certificate status is missing' TYPE 'E'.
  ENDIF.

ENDFORM.

*---------------------------------------------------------------------*
* CITIZEN REGISTRATION
*---------------------------------------------------------------------*
FORM citizen_registration.

  CLEAR gs_workflow.

  gs_workflow-step_no = '01'.
  gs_workflow-module = 'Citizen Registration'.
  gs_workflow-activity = 'Register citizen details'.
  gs_workflow-input_data =
    'Citizen ID, Name, DOB, Mobile, Email, Address'.
  gs_workflow-output_data =
    'Citizen information validated'.
  gs_workflow-status = 'COMPLETED'.
  gs_workflow-remarks =
    'Citizen details processed successfully'.

  APPEND gs_workflow TO gt_workflow.

  gv_completed = gv_completed + 1.

ENDFORM.

*---------------------------------------------------------------------*
* APPLICATION CREATION
*---------------------------------------------------------------------*
FORM application_creation.

  CLEAR gs_workflow.

  IF gv_application_status = 'CREATED'.
    gv_application_status = 'SUBMITTED'.
  ENDIF.

  gs_workflow-step_no = '02'.
  gs_workflow-module = 'Application Management'.
  gs_workflow-activity =
    'Create citizen service application'.
  gs_workflow-input_data =
    'Citizen ID and Certificate Type'.
  gs_workflow-output_data =
    'Application created successfully'.
  gs_workflow-status = 'COMPLETED'.
  gs_workflow-remarks =
    'Application created and submitted successfully'.

  APPEND gs_workflow TO gt_workflow.

  gv_completed = gv_completed + 1.

ENDFORM.

*---------------------------------------------------------------------*
* DOCUMENT VERIFICATION
*---------------------------------------------------------------------*
FORM document_verification.

  CLEAR gs_workflow.

  IF gv_document_status = 'PENDING'.
    gv_document_status = 'VERIFIED'.
  ENDIF.

  gs_workflow-step_no = '03'.
  gs_workflow-module = 'Document Verification'.
  gs_workflow-activity =
    'Verify submitted documents'.
  gs_workflow-input_data =
    'Document ID and Document Type'.
  gs_workflow-output_data =
    'Document verification status'.
  gs_workflow-status = 'COMPLETED'.
  gs_workflow-remarks =
    'Required document information verified successfully'.

  APPEND gs_workflow TO gt_workflow.

  gv_completed = gv_completed + 1.

ENDFORM.

*---------------------------------------------------------------------*
* APPLICATION PROCESSING
*---------------------------------------------------------------------*
FORM application_processing.

  CLEAR gs_workflow.

  IF gv_document_status = 'VERIFIED'.
    gv_application_status = 'PROCESSED'.
  ENDIF.

  gs_workflow-step_no = '04'.
  gs_workflow-module = 'Application Processing'.
  gs_workflow-activity =
    'Process verified application'.
  gs_workflow-input_data =
    'Application and verification details'.
  gs_workflow-output_data =
    'Application ready for certificate process'.
  gs_workflow-status = 'COMPLETED'.
  gs_workflow-remarks =
    'Application processed after document verification'.

  APPEND gs_workflow TO gt_workflow.

  gv_completed = gv_completed + 1.

ENDFORM.

*---------------------------------------------------------------------*
* CERTIFICATE PROCESSING
*---------------------------------------------------------------------*
FORM certificate_processing.

  CLEAR gs_workflow.

  IF gv_application_status = 'PROCESSED'.
    gv_certificate_status = 'GENERATED'.
  ENDIF.

  gs_workflow-step_no = '05'.
  gs_workflow-module = 'Certificate Processing'.
  gs_workflow-activity =
    'Process certificate information'.
  gs_workflow-input_data =
    'Verified application details'.
  gs_workflow-output_data =
    'Certificate information prepared'.
  gs_workflow-status = 'COMPLETED'.
  gs_workflow-remarks =
    'Certificate generated for processed application'.

  APPEND gs_workflow TO gt_workflow.

  gv_completed = gv_completed + 1.

ENDFORM.

*---------------------------------------------------------------------*
* UPDATE APPLICATION STATUS
*---------------------------------------------------------------------*
FORM update_application_status.

  CLEAR gs_workflow.

  IF gv_certificate_status = 'GENERATED'.
    gv_application_status = 'COMPLETED'.
  ENDIF.

  gs_workflow-step_no = '06'.
  gs_workflow-module = 'Status Management'.
  gs_workflow-activity =
    'Update application status'.
  gs_workflow-input_data =
    'Application processing result'.
  gs_workflow-output_data =
    'Final application status'.
  gs_workflow-status = 'COMPLETED'.
  gs_workflow-remarks =
    'Application completed successfully'.

  APPEND gs_workflow TO gt_workflow.

  gv_completed = gv_completed + 1.

ENDFORM.

*---------------------------------------------------------------------*
* FINAL WORKFLOW SUMMARY
*---------------------------------------------------------------------*
FORM prepare_final_summary.

  CLEAR gs_workflow.

  gs_workflow-step_no = '07'.
  gs_workflow-module = 'Final Reporting'.
  gs_workflow-activity =
    'Prepare project workflow summary'.
  gs_workflow-input_data =
    'Completed workflow activities'.
  gs_workflow-output_data =
    'Final workflow report'.
  gs_workflow-status = 'COMPLETED'.
  gs_workflow-remarks =
    'Complete project workflow prepared'.

  APPEND gs_workflow TO gt_workflow.

  gv_completed = gv_completed + 1.

ENDFORM.

*---------------------------------------------------------------------*
* DISPLAY WORKFLOW
*---------------------------------------------------------------------*
FORM display_workflow.

  DATA: lo_alv TYPE REF TO cl_salv_table.

  TRY.

      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = lo_alv
        CHANGING
          t_table      = gt_workflow ).

      lo_alv->get_functions( )->set_all( abap_true ).
      lo_alv->get_columns( )->set_optimize( abap_true ).
      lo_alv->display( ).

    CATCH cx_salv_msg INTO DATA(lx_alv).

      MESSAGE lx_alv->get_text( ) TYPE 'E'.

  ENDTRY.

ENDFORM.

*---------------------------------------------------------------------*
* DISPLAY FINAL SUMMARY
*---------------------------------------------------------------------*
FORM display_summary.

  DATA: lt_summary TYPE STANDARD TABLE OF ty_workflow,
        ls_summary TYPE ty_workflow,
        lo_summary TYPE REF TO cl_salv_table.

  CLEAR ls_summary.
  ls_summary-step_no = '01'.
  ls_summary-module = 'APPLICATION'.
  ls_summary-activity = 'Application Status'.
  ls_summary-output_data = gv_application_status.
  ls_summary-status = 'CURRENT'.

  APPEND ls_summary TO lt_summary.

  CLEAR ls_summary.
  ls_summary-step_no = '02'.
  ls_summary-module = 'DOCUMENT'.
  ls_summary-activity = 'Document Status'.
  ls_summary-output_data = gv_document_status.
  ls_summary-status = 'CURRENT'.

  APPEND ls_summary TO lt_summary.

  CLEAR ls_summary.
  ls_summary-step_no = '03'.
  ls_summary-module = 'CERTIFICATE'.
  ls_summary-activity = 'Certificate Status'.
  ls_summary-output_data = gv_certificate_status.
  ls_summary-status = 'CURRENT'.

  APPEND ls_summary TO lt_summary.

  CLEAR ls_summary.
  ls_summary-step_no = '04'.
  ls_summary-module = 'PROJECT'.
  ls_summary-activity = 'Completed Workflow Steps'.
  ls_summary-output_data = gv_completed.
  ls_summary-status = 'COMPLETED'.

  APPEND ls_summary TO lt_summary.

  TRY.

      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = lo_summary
        CHANGING
          t_table      = lt_summary ).

      lo_summary->get_functions( )->set_all( abap_true ).
      lo_summary->get_columns( )->set_optimize( abap_true ).
      lo_summary->display( ).

    CATCH cx_salv_msg INTO DATA(lx_summary).

      MESSAGE lx_summary->get_text( ) TYPE 'E'.

  ENDTRY.

ENDFORM.
