From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Does anything ever enter through startup_64 in head_64.S?
Date: Wed, 07 Dec 2016 16:47:07 +0000
Message-ID: <24722.1481129227@warthog.procyon.org.uk>
References: <20161207152434.GB5462@codeblueprint.co.uk> <21775.1481123477@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161207152434.GB5462-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Content-ID: <24721.1481129227.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> > Does anything ever enter the kernel through startup_64 in head_64.S?[*]  Do
> > all 64-bit mode entries always enter through one of the EFI entry points?
>  
> Which head_64.S? There are two ;-)
> 
> Assuming you mean startup_64 in boot/compressed/head_64.S, then the
> answer is "yes". 64-bit BIOS boot loaders will jump there.

Sorry, yes, that one.

> I'm fairly sure it's possible to boot that way on EFI too, you just
> lose some of the newer functionality that is dependent on the EFI boot
> stub. But I don't remember the last time I tried it.
> 
> In general, we've always tried to maintain backwards compat, but you
> don't get the new features without switching to the EFI entry points.
> 
> Whether or not any distros are still using the old 0x200 entry point
> for EFI is a good question, though.

I think I have to assume that there might be.

David
