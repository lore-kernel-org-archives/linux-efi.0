From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [REGRESSION] EFI mixed mode patch triggers boot failure
Date: Fri, 27 Jan 2017 22:34:41 +0000
Message-ID: <20170127223441.GJ31613@codeblueprint.co.uk>
References: <dc0bc031-f20e-9ad0-57f4-cfa1e04f8f05@redhat.com>
 <7af87cde-ce79-d6e8-0797-54069a77f42b@redhat.com>
 <20161020120357.GB19876@codeblueprint.co.uk>
 <e34311e8-fe39-3b65-bd6d-8f1594e56336@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e34311e8-fe39-3b65-bd6d-8f1594e56336-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Justin Forbes <jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 24 Oct, at 12:54:11PM, Laura Abbott wrote:
> 
> Was out for a few days, reporter says the below patch does not work.
> There was some confusion with secure boot so I've asked them to re-test
> with efi=old_map and secure boot off.

FYI, you may want to ask the reporter to try out Jiri's patch if this
is still an issue for them,

  https://lkml.kernel.org/r/alpine.LSU.2.20.1701271638240.25515-YHPUNQjx9ReKbouaWp301Q@public.gmane.org
