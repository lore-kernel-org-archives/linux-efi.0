From: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Subject: Re: [PATCH] efi: split efisubsystem from efivars
Date: Mon, 4 Feb 2013 15:10:55 +0100
Message-ID: <CAG-2HqWC2XVnpck97A+ZqZtom0hr6cphrrirJC2Bx+BgBt4DZg@mail.gmail.com>
References: <1359128215-1331-1-git-send-email-teg@jklm.no> <1359973581.7515.101.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359973581.7515.101.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Chun-Yi Lee <jlee-IBi9RG/b67k@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 4, 2013 at 11:26 AM, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Tom, this patch is still on my radar.

Great, thanks for letting me know.

> It's just that I thought it was
> *such* a good idea I decided to chainsaw the existing efivars code to
> make it more modular and eventually split things up into a new
> drivers/firmware/efi directory.

Nice. I was going to resend a rebased version on top of the latest
-rc, but I'll hold off on that until I see what you end up doing.

Cheers,

Tom
