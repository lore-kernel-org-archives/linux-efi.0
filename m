From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/4] efi: efivars: don't rely on blocking operations in
 non-blocking set_var()
Date: Fri, 27 Nov 2015 21:18:36 +0000
Message-ID: <20151127211836.GB13918@codeblueprint.co.uk>
References: <1447940191-30705-1-git-send-email-ard.biesheuvel@linaro.org>
 <1447940191-30705-3-git-send-email-ard.biesheuvel@linaro.org>
 <20151126095441.GA2765@codeblueprint.co.uk>
 <CAKv+Gu8XqP+MgT1vkC-CLkEZ=p+X2tA3fQuprUCRJ1UhrFz-rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8XqP+MgT1vkC-CLkEZ=p+X2tA3fQuprUCRJ1UhrFz-rg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 26 Nov, at 01:06:27PM, Ard Biesheuvel wrote:
> 
> How would this be affected by things like suspend/resume, hibernation
> or variable accesses made in SMM context (i.e., which the kernel knows
> nothing about)
> If we need to take all of that into account as well, we're probably
> better off adding a nonblocking query_variable_info() call after all,
> and wiring it up to efi_query_variable_store(), i.e., make it take a
> 'bool nonblocking' argument and choose between the two versions of
> each of the hooks it uses.

I *think* that'd be OK. The thing I wanted to avoid was a
proliferation of nonblocking versions of the standard EFI calls, but
limiting it to adding query_variable_info() doesn't seem too bad.

Let me think about it over the weekend. 
