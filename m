Return-Path: <SRS0=gNor=YJ=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDACECE599
	for <linux-efi@archiver.kernel.org>; Wed, 16 Oct 2019 23:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE18620872
	for <linux-efi@archiver.kernel.org>; Wed, 16 Oct 2019 23:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388246AbfJPXZ2 (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 16 Oct 2019 19:25:28 -0400
Received: from smtprelay0045.hostedemail.com ([216.40.44.45]:56242 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725970AbfJPXZ2 (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 16 Oct 2019 19:25:28 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id B26C85832;
        Wed, 16 Oct 2019 23:25:26 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: flock47_2f3f58b870741
X-Filterd-Recvd-Size: 2044
Received: from XPS-9350.home (unknown [47.151.152.152])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Wed, 16 Oct 2019 23:25:24 +0000 (UTC)
Message-ID: <3f2feed96a3569e2a27051864ae5e8a84ce634b4.camel@perches.com>
Subject: Re: [PATCH v3] x86, efi: never relocate kernel below lowest
 acceptable address
From:   Joe Perches <joe@perches.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Kairui Song <kasong@redhat.com>, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Matthew Garrett <matthewgarrett@google.com>,
        Baoquan He <bhe@redhat.com>, Dave Young <dyoung@redhat.com>,
        x86@kernel.org, linux-efi@vger.kernel.org,
        linux-integrity@vger.kernel.org
Date:   Wed, 16 Oct 2019 16:25:23 -0700
In-Reply-To: <20191016154842.GJ1138@zn.tnic>
References: <20191012034421.25027-1-kasong@redhat.com>
         <20191014101419.GA4715@zn.tnic> <20191014202111.GP15552@linux.intel.com>
         <20191014211825.GJ4715@zn.tnic> <20191016152014.GC4261@linux.intel.com>
         <fb0e7c13da405970d5cbd59c10005daaf970b8da.camel@perches.com>
         <20191016154842.GJ1138@zn.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, 2019-10-16 at 17:48 +0200, Borislav Petkov wrote:
> On Wed, Oct 16, 2019 at 08:23:56AM -0700, Joe Perches wrote:
> > ?  examples please.
> 
> From this very thread:
> 
> \sEfi\s, \sefi\s, \seFI\s etc should be "EFI"
> 
> I'm thinking perhaps start conservatively and catch the most often
> misspelled ones in commit messages or comments. "CPU", "SMT", "MCE",
> "MCA", "PCI" etc come to mind.
> 
> > checkpatch has a db for misspellings, I supposed another for
> > acronyms could be added,
> 
> Doesn't have to be another one - established acronyms are part of the
> dictionary too.

Couldn't work.  The dictionary is case insensitive.


