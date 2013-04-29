From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next: Tree for Apr 26
Date: Mon, 29 Apr 2013 09:11:13 +0100
Message-ID: <517E2B21.8070009@intel.com>
References: <20130426180357.7599d1b6b7965470905dcdf3@canb.auug.org.au> <CAMuHMdWQ0rMuoH+peGMZ3=AdsYrMPpeV4_vSsLD3kaJukx=83w@mail.gmail.com> <20130429093628.b739ef3b879b6f8759bd31af@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130429093628.b739ef3b879b6f8759bd31af-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Linux-Next <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 29/04/13 00:36, Stephen Rothwell wrote:
> Commit e29c2de5f591 ("Merge tag 'v3.9-rc8' into efi-for-tip") by Matt
> Fleming from the tip tree merged v3.9-rc8 (which has 0635eb8a54cf) with
> the branch that contains 048517722cde but lost the "select UCS2_STRING"
> which should be in drivers/firmware/efi/Kconfig.

Eek, yes. Sorry about that. How should we resolve this?
