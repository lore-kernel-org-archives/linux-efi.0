From: Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Tue, 14 Nov 2017 00:20:47 +0000
Message-ID: <20171114002047.5e3b94ad@alans-desktop>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
        <14219.1509660259@warthog.procyon.org.uk>
        <1509660641.3416.24.camel@linux.vnet.ibm.com>
        <20171107230700.GJ22894@wotan.suse.de>
        <20171108061551.GD7859@linaro.org>
        <20171108194626.GQ22894@wotan.suse.de>
        <20171109014841.GF7859@linaro.org>
        <1510193857.4484.95.camel@linux.vnet.ibm.com>
        <20171109044619.GG7859@linaro.org>
        <20171111023240.2398ca55@alans-desktop>
        <20171113174250.GA22894@wotan.suse.de>
        <20171113210848.4dc344bd@alans-desktop>
        <454.1510609487@warthog.procyon.org.uk>
        <CA+55aFzrK29hbxoKs3GsvVUY4_uR7aBgZv2eeVyVq7MzfATY3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFzrK29hbxoKs3GsvVUY4_uR7aBgZv2eeVyVq7MzfATY3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "AKASHI, Takahiro" <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jan Blunck <jblunck-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, Marcus Meissner <meissner-l3A5Bk7waGM@public.gmane.org>, Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 13 Nov 2017 14:09:10 -0800
Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:

> On Mon, Nov 13, 2017 at 1:44 PM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > Whilst that may be true, we either have to check signatures on every bit of
> > firmware that the appropriate driver doesn't say is meant to be signed or not
> > bother.  
> 
> I vote for "not bother".
> 
> Seriously, if you have firmware in /lib/firmware, and you don't trust
> it, what the hell are you doing?

Booting a computer 8) - does anyone trust firmware ???


That aside if you can replace the firmware with your own, and your own
firmware compromises the system then you have a privilege escalation from
CAP_SYS_DAC to CAP_SYS_RAWIO just as you do with unsigned modules

(you can't load modules without lots of rights but who cares because you
can simply use cp to put them there with lesser rights and let the kernel
do it).


Alan
