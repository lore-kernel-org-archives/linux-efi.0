Return-Path: <SRS0=gNor=YJ=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C9AFA372A
	for <linux-efi@archiver.kernel.org>; Wed, 16 Oct 2019 17:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A7FB21A49
	for <linux-efi@archiver.kernel.org>; Wed, 16 Oct 2019 17:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390071AbfJPRyv (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 16 Oct 2019 13:54:51 -0400
Received: from smtprelay0019.hostedemail.com ([216.40.44.19]:45224 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388804AbfJPRyv (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 16 Oct 2019 13:54:51 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id D6B2883E3;
        Wed, 16 Oct 2019 17:54:49 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: cap93_46fcf941bb85d
X-Filterd-Recvd-Size: 3199
Received: from XPS-9350.home (unknown [47.151.152.152])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Wed, 16 Oct 2019 17:54:47 +0000 (UTC)
Message-ID: <e6d33109f7abad1f883764828311e9965d65dd9e.camel@perches.com>
Subject: Re: [PATCH v3] x86, efi: never relocate kernel below lowest
 acceptable address
From:   Joe Perches <joe@perches.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, Kairui Song <kasong@redhat.com>,
        linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Matthew Garrett <matthewgarrett@google.com>,
        Baoquan He <bhe@redhat.com>, Dave Young <dyoung@redhat.com>,
        x86@kernel.org, linux-efi@vger.kernel.org,
        linux-integrity@vger.kernel.org
Date:   Wed, 16 Oct 2019 10:54:46 -0700
In-Reply-To: <20191016162757.GC6279@linux.intel.com>
References: <20191012034421.25027-1-kasong@redhat.com>
         <20191014101419.GA4715@zn.tnic> <20191014202111.GP15552@linux.intel.com>
         <20191014211825.GJ4715@zn.tnic> <20191016152014.GC4261@linux.intel.com>
         <fb0e7c13da405970d5cbd59c10005daaf970b8da.camel@perches.com>
         <20191016162757.GC6279@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, 2019-10-16 at 19:27 +0300, Jarkko Sakkinen wrote:
> On Wed, Oct 16, 2019 at 08:23:56AM -0700, Joe Perches wrote:
> > On Wed, 2019-10-16 at 18:20 +0300, Jarkko Sakkinen wrote: > > On Mon, Oct 14, 2019 at 11:18:25PM +0200, Borislav Petkov wrote:
> > > > On Mon, Oct 14, 2019 at 11:21:11PM +0300, Jarkko Sakkinen wrote:
> > > > > Was there a section in the patch submission documentation to point out
> > > > > when people send patches with all the possible twists for an acronym?
> > > > 
> > > > I don't think so.
> > > > 
> > > > > This is giving me constantly gray hairs with TPM patches.
> > > > 
> > > > Well, I'm slowly getting tired of repeating the same crap over and over
> > > > again about how important it is to document one's changes and to write
> > > > good commit messages. The most repeated answers I'm simply putting into
> > > > canned reply templates because, well, saying it once or twice is not
> > > > enough anymore. :-\
> > > > 
> > > > And yeah, I see your pain. Same here, actually.
> > > > 
> > > > In the acronym case, I'd probably add a regex to my patch massaging
> > > > script and convert those typos automatically and be done with it.
> > > 
> > > Wonder if checkpatch.pl could be extended to know acronyms e.g. have a
> > > db of known acronyms.
> > 
> > ?  examples please.
> > 
> > checkpatch has a db for misspellings, I supposed another for
> > acronyms could be added, but how would false positives be avoided?
> 
> TPM should be always TPM, e.g. not tpm. EFI should be always, e.g.
> not efi.

I think it's not possible to distinguish between
proper and improper uses.  For instance:

$ git grep -w tpm | wc -l
328
$ git grep -w TPM | wc -l
566

$ git grep -w efi | wc -l
851
$ git grep -w EFI | wc -l
915


