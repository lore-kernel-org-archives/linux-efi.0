From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 8/8] efi: Add EFI_SECURE_BOOT bit [ver #6]
Date: Mon, 16 Jan 2017 15:40:25 +0000
Message-ID: <819.1484581225@warthog.procyon.org.uk>
References: <20170116134041.GA27351@codeblueprint.co.uk> <20170111145138.GB29649@codeblueprint.co.uk> <148120020832.5854.5448601415491330495.stgit@warthog.procyon.org.uk> <148120026820.5854.13036556358308461345.stgit@warthog.procyon.org.uk> <7979.1484148564@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170116134041.GA27351-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Content-ID: <818.1484581225.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> > > Before we add more efi.flags bits I'd like this series to include the
> > > patch that makes use of EFI_SECURE_BOOT. Alternatively, you move this
> > > last patch to a new series.
> > 
> > Are you willing to take the kernel lock-down patches also?
> 
> I'm happy to take them through the EFI tree provided that they've been
> Reviewed/Ack-ed by the security folks.

Thinking further about it, it might be best to push the EFI_SECURE_BOOT flag
into a later series and exclude that patch from this one.

David
