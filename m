From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/4] efi: efivars: don't rely on blocking operations in
 non-blocking set_var()
Date: Mon, 30 Nov 2015 11:12:30 +0000
Message-ID: <20151130111230.GA2441@codeblueprint.co.uk>
References: <1447940191-30705-1-git-send-email-ard.biesheuvel@linaro.org>
 <1447940191-30705-3-git-send-email-ard.biesheuvel@linaro.org>
 <20151126095441.GA2765@codeblueprint.co.uk>
 <CAKv+Gu8XqP+MgT1vkC-CLkEZ=p+X2tA3fQuprUCRJ1UhrFz-rg@mail.gmail.com>
 <20151127211836.GB13918@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151127211836.GB13918-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 27 Nov, at 09:18:36PM, Matt Fleming wrote:
> 
> I *think* that'd be OK. The thing I wanted to avoid was a
> proliferation of nonblocking versions of the standard EFI calls, but
> limiting it to adding query_variable_info() doesn't seem too bad.
> 
> Let me think about it over the weekend. 

I couldn't come up with anything better. Go for it!
