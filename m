Return-Path: <SRS0=DG+M=7B=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E11C433DF
	for <linux-efi@archiver.kernel.org>; Tue, 19 May 2020 08:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CD0320709
	for <linux-efi@archiver.kernel.org>; Tue, 19 May 2020 08:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589876573;
	bh=taTqhXPC+5HSD9rwB+hNspqnBlsRXURk0K9Hvj+mkwQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=e0jSIJRY08K49VmpavdDdkhiVl21X1yNH8RaqoazsamX1A+u8og5VPBi8Qfc4Qljw
	 5p9Lo9v2sdn0zgHDyJGPiK48LLt60t7j9fLExsR928im02YJW56fRbkwyF3lXF471F
	 WLJEBG6J3mqtloUYYcIsmE9orsRc9wjBf9ey96TA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgESIWx (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 19 May 2020 04:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbgESIWx (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Tue, 19 May 2020 04:22:53 -0400
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1784F20709
        for <linux-efi@vger.kernel.org>; Tue, 19 May 2020 08:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589876572;
        bh=taTqhXPC+5HSD9rwB+hNspqnBlsRXURk0K9Hvj+mkwQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=I3NcR1X0O/7SPHDK7qIYqzdcR1yos5BLvJacTb0awnXvQvr1F0vimd5ggCXWjenYI
         7gu1MmZBuhwy9AyWJwAW+i9/PkUZYd5vwJQGkEJudX3/nQmhQjsULj8Ojqpn5jB1i+
         LyHFYSRlro9cCypJhwHqvtA+HeAfHFqpHrFAaY7c=
Received: by mail-il1-f174.google.com with SMTP id b15so12549781ilq.12
        for <linux-efi@vger.kernel.org>; Tue, 19 May 2020 01:22:52 -0700 (PDT)
X-Gm-Message-State: AOAM5314yCeccbw8dVsx/uMzg2TPX54xHi13Ldgf08qmJ7f48kkNpSEz
        DNbqI1TDE/nLktng3kbNKUHT58sBkWaaeOHNXVY=
X-Google-Smtp-Source: ABdhPJzjQehU1UTKdZT35gjaiEFTL90aInT7FsI4Y2a6TB07jXwyPUEAB0rNmKiKiokJAnnUGOnPbGKmYZN44aRT3Xo=
X-Received: by 2002:a92:bb55:: with SMTP id w82mr20444941ili.211.1589876571402;
 Tue, 19 May 2020 01:22:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200518190716.751506-1-nivedita@alum.mit.edu> <20200518190716.751506-18-nivedita@alum.mit.edu>
In-Reply-To: <20200518190716.751506-18-nivedita@alum.mit.edu>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 19 May 2020 10:22:40 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE=YowWg2CbqXVhPcXoq3eZdowzTnGxLkpD5xcf29fHhw@mail.gmail.com>
Message-ID: <CAMj1kXE=YowWg2CbqXVhPcXoq3eZdowzTnGxLkpD5xcf29fHhw@mail.gmail.com>
Subject: Re: [PATCH 17/24] efi/libstub: Implement printk-style logging
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     linux-efi <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Mon, 18 May 2020 at 21:07, Arvind Sankar <nivedita@alum.mit.edu> wrote:
>
> Use the efi_printk function in efi_info/efi_err, and add efi_debug. This
> allows formatted output at different log levels.
>
> Add the notion of a loglevel instead of just quiet/not-quiet, and
> parse the debug kernel parameter in addition to quiet.
>
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> ---
>  .../firmware/efi/libstub/efi-stub-helper.c    | 29 +++++++++++++++++--
>  drivers/firmware/efi/libstub/efistub.h        | 14 +++++----
>  2 files changed, 35 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
> index 5ecafc57619a..c0278a8063b7 100644
> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
> @@ -11,6 +11,7 @@
>
>  #include <linux/efi.h>
>  #include <linux/kernel.h>
> +#include <linux/printk.h> /* For CONSOLE_LOGLEVEL_* */
>  #include <asm/efi.h>
>
>  #include "efistub.h"
> @@ -18,7 +19,7 @@
>  bool efi_nochunk;
>  bool efi_nokaslr;
>  bool efi_noinitrd;
> -bool efi_quiet;
> +int efi_loglevel = CONSOLE_LOGLEVEL_DEFAULT;
>  bool efi_novamap;
>
>  static bool efi_nosoftreserve;
> @@ -58,6 +59,28 @@ int efi_printk(const char *fmt, ...)
>         char printf_buf[256];
>         va_list args;
>         int printed;
> +       int loglevel = printk_get_level(fmt);
> +
> +       switch (loglevel) {
> +       case '0' ... '9':
> +               loglevel -= '0';
> +               break;
> +       default:
> +               /*
> +                * Use loglevel -1 for cases where we just want to print to
> +                * the screen.
> +                */
> +               loglevel = -1;
> +               break;
> +       }
> +
> +       if (loglevel >= efi_loglevel)
> +               return 0;
> +
> +       if (loglevel >= 0)
> +               efi_puts("EFI stub: ");
> +
> +       fmt = printk_skip_level(fmt);
>
>         va_start(args, fmt);
>         printed = vsnprintf(printf_buf, sizeof(printf_buf), fmt, args);
> @@ -100,7 +123,9 @@ efi_status_t efi_parse_options(char const *cmdline)
>                 if (!strcmp(param, "nokaslr")) {
>                         efi_nokaslr = true;
>                 } else if (!strcmp(param, "quiet")) {
> -                       efi_quiet = true;
> +                       efi_loglevel = CONSOLE_LOGLEVEL_QUIET;
> +               } else if (!strcmp(param, "debug")) {
> +                       efi_loglevel = CONSOLE_LOGLEVEL_DEBUG;

Should we wire this to 'efi=debug' instead?

>                 } else if (!strcmp(param, "noinitrd")) {
>                         efi_noinitrd = true;
>                 } else if (!strcmp(param, "efi") && val) {
> diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
> index caa7dcc71c69..3a323a009836 100644
> --- a/drivers/firmware/efi/libstub/efistub.h
> +++ b/drivers/firmware/efi/libstub/efistub.h
> @@ -6,6 +6,7 @@
>  #include <linux/compiler.h>
>  #include <linux/efi.h>
>  #include <linux/kernel.h>
> +#include <linux/kern_levels.h>
>  #include <linux/types.h>
>  #include <asm/efi.h>
>
> @@ -34,7 +35,7 @@
>  extern bool efi_nochunk;
>  extern bool efi_nokaslr;
>  extern bool efi_noinitrd;
> -extern bool efi_quiet;
> +extern int efi_loglevel;
>  extern bool efi_novamap;
>
>  extern const efi_system_table_t *efi_system_table;
> @@ -49,11 +50,12 @@ extern const efi_system_table_t *efi_system_table;
>
>  #endif
>
> -#define efi_info(msg)          do {                    \
> -       if (!efi_quiet) efi_puts("EFI stub: "msg);      \
> -} while (0)
> -
> -#define efi_err(msg) efi_puts("EFI stub: ERROR: "msg)
> +#define efi_info(fmt, ...) \
> +       efi_printk(KERN_INFO fmt, ##__VA_ARGS__)
> +#define efi_err(fmt, ...) \
> +       efi_printk(KERN_ERR "ERROR: " fmt, ##__VA_ARGS__)
> +#define efi_debug(fmt, ...) \
> +       efi_printk(KERN_DEBUG "DEBUG: " fmt, ##__VA_ARGS__)
>
>  /* Helper macros for the usual case of using simple C variables: */
>  #ifndef fdt_setprop_inplace_var
> --
> 2.26.2
>
