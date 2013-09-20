From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 09/17] Move unicode to ASCII conversion to shared
 function.
Date: Fri, 20 Sep 2013 10:27:13 +0100
Message-ID: <20130920092713.GD4785@console-pimps.org>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
 <1379391093-27948-10-git-send-email-roy.franz@linaro.org>
 <20130919034406.GA26385@angband.pl>
 <CAFECyb-tTaCEqUHUh23MaJf-P42ZpodFKeNG=kE+vmmi-gyKrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFECyb-tTaCEqUHUh23MaJf-P42ZpodFKeNG=kE+vmmi-gyKrw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Adam Borowski <kilobyte-b9QjgO8OEXPVItvQsEIGlw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 18 Sep, at 09:48:44PM, Roy Franz wrote:
> Would it be acceptable to fix the naming/comments, and convert values
> above 126 to '?'
> in the current patchset, and address a more thorough fix in another patch set?
> The ARM and ARM64 EFI stub patchsets that are mostly complete depend
> on this one,
> so getting this merged soon would be helpful.

Just fixing the function name and comments is enough for this patch
series. Anything else should be separate.

-- 
Matt Fleming, Intel Open Source Technology Center
