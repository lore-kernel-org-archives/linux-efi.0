From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [REGRESSION] EFI mixed mode patch triggers boot failure
Date: Mon, 30 Jan 2017 14:10:37 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1701301409270.25515@cbobk.fhfr.pm>
References: <dc0bc031-f20e-9ad0-57f4-cfa1e04f8f05@redhat.com> <7af87cde-ce79-d6e8-0797-54069a77f42b@redhat.com> <20161020120357.GB19876@codeblueprint.co.uk> <e34311e8-fe39-3b65-bd6d-8f1594e56336@redhat.com> <20170127223441.GJ31613@codeblueprint.co.uk>
 <f7d8f786-6000-cbbe-feb2-c97c0378b6e9@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f7d8f786-6000-cbbe-feb2-c97c0378b6e9@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Laura Abbott <labbott@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, "x86@kernel.org" <x86@kernel.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Justin Forbes <jforbes@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 28 Jan 2017, Laura Abbott wrote:

> > > Was out for a few days, reporter says the below patch does not work.
> > > There was some confusion with secure boot so I've asked them to re-test
> > > with efi=old_map and secure boot off.
> > 
> > FYI, you may want to ask the reporter to try out Jiri's patch if this
> > is still an issue for them,
> > 
> >   https://lkml.kernel.org/r/alpine.LSU.2.20.1701271638240.25515@cbobk.fhfr.pm
> > 
> 
> Thanks! I pulled this into the latest Fedora update so I'll be asking
> a couple of people to test.

BTW where exactly is this tracked for Fedora, please? I'd like to get an 
idea how widespread this behavior is among different BIOS vendors.

I've found

	https://bugzilla.redhat.com/show_bug.cgi?id=1384238

is that the primary tracking bug on your side?

Thanks,

-- 
Jiri Kosina
SUSE Labs
