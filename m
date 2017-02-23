From: Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [REGRESSION] EFI mixed mode patch triggers boot failure
Date: Thu, 23 Feb 2017 21:34:17 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1702232132360.24579@cbobk.fhfr.pm>
References: <dc0bc031-f20e-9ad0-57f4-cfa1e04f8f05@redhat.com> <7af87cde-ce79-d6e8-0797-54069a77f42b@redhat.com> <20161020120357.GB19876@codeblueprint.co.uk> <e34311e8-fe39-3b65-bd6d-8f1594e56336@redhat.com> <20170127223441.GJ31613@codeblueprint.co.uk>
 <f7d8f786-6000-cbbe-feb2-c97c0378b6e9@redhat.com> <alpine.LSU.2.20.1701301409270.25515@cbobk.fhfr.pm> <1208352f-ab6a-4489-d6b1-2f3e537f5e60@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1208352f-ab6a-4489-d6b1-2f3e537f5e60-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Justin Forbes <jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Gary Lin <glin-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 1 Feb 2017, Laura Abbott wrote:

> That's the main one where debugging was happening. There may be a couple 
> of others floating around that I hadn't had time to fully investigate. 
> I'll dupe them to the above if I find them.

[ adding Joey and Gary to CC ]

Laura,

have you by any chance heard back from anyone who's been able to trigger 
the original problem?

We're now trying to figure out how widespread the problem might be (and 
which part of the BIOS is to blame), so any further datapoints would be 
helpful.

Thanks,

-- 
Jiri Kosina
SUSE Labs
