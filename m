Return-Path: <SRS0=LPq2=UX=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEB7C43613
	for <linux-efi@archiver.kernel.org>; Mon, 24 Jun 2019 16:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9566C20657
	for <linux-efi@archiver.kernel.org>; Mon, 24 Jun 2019 16:23:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfFXQXe (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 24 Jun 2019 12:23:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:5036 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbfFXQXe (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 24 Jun 2019 12:23:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jun 2019 09:23:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,412,1557212400"; 
   d="scan'208";a="182666147"
Received: from akolosov-mobl1.ger.corp.intel.com ([10.249.33.80])
  by fmsmga001.fm.intel.com with ESMTP; 24 Jun 2019 09:23:31 -0700
Message-ID: <8acf82b7066f260332f9353682d4b83e44b68b88.camel@linux.intel.com>
Subject: Re: [PATCH] drivers: firmware: efi: fix gcc warning -Wint-conversion
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Matthew Garrett <mjg59@google.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Hariprasad Kelam <hariprasad.kelam@gmail.com>,
        tpmdd-devel@lists.sourceforge.net,
        linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Mon, 24 Jun 2019 19:23:30 +0300
In-Reply-To: <CACdnJusDaGkTAEWJ41+dGQxRWqxbgk8a_iNq5pCuGp=NsdEXgg@mail.gmail.com>
References: <20190615040210.GA9112@hari-Inspiron-1545>
         <CAKv+Gu9-wiJNxPsVn06dBSU8Gchg8LjV=mi0cThZUWywmt2xzQ@mail.gmail.com>
         <CACdnJuudmE-MNuO7z87Mm65VaXbRzhOrBEpU5F=yC67uSLytGQ@mail.gmail.com>
         <20190620213722.GA17841@linux.intel.com>
         <CACdnJusDaGkTAEWJ41+dGQxRWqxbgk8a_iNq5pCuGp=NsdEXgg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Thu, 2019-06-20 at 15:00 -0700, Matthew Garrett wrote:
> On Thu, Jun 20, 2019 at 2:37 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> > Right! OK, I squashed just the fix to the earlier patch. Master and
> > next are updated. Can you take a peek of [1] and see if it looks
> > legit given all the fuzz around these changes? Then I'm confident
> > enough to do the 5.3 PR.
> 
> All looks good to me. Thanks!

Thank you! I'll send the PR now.

/Jarkko

