From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH V4 0/4] Handle EFI_INVALID_PARAMETER from ExitBootServices
Date: Fri, 19 Aug 2016 12:43:50 +0100
Message-ID: <20160819114350.GS30909@codeblueprint.co.uk>
References: <1471288933-31810-1-git-send-email-jhugo@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1471288933-31810-1-git-send-email-jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 15 Aug, at 01:22:09PM, Jeffrey Hugo wrote:
> According to the UEFI spec, the UEFI OS Loader (aka the stub) should
> transition from UEFI to the OS by getting the current memory map from UEFI,
> then calling ExitBootServices.  The spec states that ExitBootServices may
> return EFI_INVALID_PARAMETER if the memory map reference provided by the stub
> is not current, ie UEFI handled some event prior to ExitBootServices which
> modified the map.  The spec states that to handle this scenario, the stub shall
> get the updated map, and invoke ExitBootServices again.  The spec also states
> that once ExitBootServices is invoked, even if it returns error, the only
> APIs the stub is allowed to invoke is GetMemoryMap and ExitBootServices.
> 
> The EFI_INVALID_PARAMETER scenario has been seen in the wild previously in
> x86 but the fix - d3768d885c6c ("x86, efi: retry ExitBootServices() on failure")
> still violates the spec.  The FDT code does not handle this scenario, but
> instances of it are now observed.
> 
> This patch series aims to provide a spec complaint solution that can be reused
> in all stubs, thus preventing each arch or variant from reinventing the wheel
> and likely getting it wrong.

This Jeffrey. This version looks much better and it passes all my
tests.

Queued up in 'urgent'.
