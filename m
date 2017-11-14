From: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel lockdown
Date: Tue, 14 Nov 2017 15:37:43 -0500
Message-ID: <CACdnJutfFa2CSf1jFvKtBdTtPWcu0aKdm8ZDdQmD+yTC4GQG6g@mail.gmail.com>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <14219.1509660259@warthog.procyon.org.uk> <1509660641.3416.24.camel@linux.vnet.ibm.com>
 <20171107230700.GJ22894@wotan.suse.de> <20171108061551.GD7859@linaro.org>
 <20171108194626.GQ22894@wotan.suse.de> <20171109014841.GF7859@linaro.org>
 <1510193857.4484.95.camel@linux.vnet.ibm.com> <20171109044619.GG7859@linaro.org>
 <20171111023240.2398ca55@alans-desktop> <20171113174250.GA22894@wotan.suse.de>
 <20171113210848.4dc344bd@alans-desktop> <454.1510609487@warthog.procyon.org.uk>
 <CA+55aFzrK29hbxoKs3GsvVUY4_uR7aBgZv2eeVyVq7MzfATY3w@mail.gmail.com>
 <1510662098.3711.139.camel@linux.vnet.ibm.com> <CA+55aFzvuvqOfsJ9arzcc1QbTGs+U-TsNmsyem9UAVVQC8YkZQ@mail.gmail.com>
 <CACdnJuvP=0AHGtfGJ5+cT+kHRy3fU4BLjwkvzP0rLO6q5ejAQQ@mail.gmail.com>
 <CA+55aFxeLwgwxh2iJTf6Dz0T_a_TZfTdhBw5TkcSsCmjt2N5pw@mail.gmail.com>
 <CACdnJutiOr0RZEW-9Z4i__o-O2B69cFknqo14Nu2G0_JQaE+xw@mail.gmail.com> <CA+55aFwN+yaLg_-jPKiQ4xYBc2zz3ogcHCY9nxMHGiAJxoCU6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFwN+yaLg_-jPKiQ4xYBc2zz3ogcHCY9nxMHGiAJxoCU6w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "AKASHI, Takahiro" <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jan Blunck <jblunck-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, Marcus Meissner <meissner-l3A5Bk7waGM@public.gmane.org>, Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 14, 2017 at 3:35 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Tue, Nov 14, 2017 at 12:31 PM, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>
>>> This is all theoretical security masturbation. The _real_ attacks have
>>> been elsewhere.
>>
>> People made the same argument about Secure Boot, and then we
>> discovered that people *were* attacking the boot chain. As we secure
>> other components, the attackers move elsewhere. This is an attempt to
>> block off an avenue of attack before it's abused.
>
> The thing is, if you have attested the system from boot, then you've
> already attested the firmware before it even gets loaded.
>
> And if you haven't, then you can't trust anything else anyway.

Sure you can. You don't need attestation to be able to assert that the
system only booted signed code and that only you have control over
that signing key.
