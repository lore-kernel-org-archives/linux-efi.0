From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH V2 2/4] efi/libstub: Introduce ExitBootServices helper
Date: Mon, 1 Aug 2016 13:03:12 +0100
Message-ID: <20160801120312.GE3636@codeblueprint.co.uk>
References: <1469132894-17103-1-git-send-email-jhugo@codeaurora.org>
 <1469132894-17103-3-git-send-email-jhugo@codeaurora.org>
 <20160727180318.GI31759@codeblueprint.co.uk>
 <32feffc6-a789-fcce-0e53-cc473247bb76@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32feffc6-a789-fcce-0e53-cc473247bb76-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 27 Jul, at 01:21:17PM, Jeffrey Hugo wrote:
> On 7/27/2016 12:03 PM, Matt Fleming wrote:
> >
> >Why not move the priv_func call until after we know ExitBootServices()
> >returned successfully? That way we don't have to make two calls and
> >the callee doesn't need to handle that.
> >
> 
> It keeps the code flow for FDT (patch 3 in the series) and x86 (patch 4) the
> same as before, and x86 seems to require that its function occurs before
> ExitBootServices().
> 
> exit_boot() calls alloc_e820ext() based on the contents of the current
> memory map, which invokes allocate_pool().  Per my understanding of the
> spec, allocate_pool() should not be called after ExitBootServices(), and per
> my understanding of the x86 code, alloc_e820ext() needs to be called between
> getting the current memory map, and ExitBootServices().  Am I incorrect, and
> there is an option to restructure the x86 code so that this ordering is not
> required?

On second thoughts, it's fine as-is.
