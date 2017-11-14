From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel lockdown
Date: Tue, 14 Nov 2017 12:35:11 -0800
Message-ID: <CA+55aFwN+yaLg_-jPKiQ4xYBc2zz3ogcHCY9nxMHGiAJxoCU6w@mail.gmail.com>
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
 <CA+55aFxeLwgwxh2iJTf6Dz0T_a_TZfTdhBw5TkcSsCmjt2N5pw@mail.gmail.com> <CACdnJutiOr0RZEW-9Z4i__o-O2B69cFknqo14Nu2G0_JQaE+xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CACdnJutiOr0RZEW-9Z4i__o-O2B69cFknqo14Nu2G0_JQaE+xw@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jan Blunck <jblunck@infradead.org>, Julia Lawall <julia.lawall@lip6.fr>, Marcus Meissner <meissner@suse.de>, Gary Lin <GLin@suse.com>, LSM List <linux-security-module@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 14, 2017 at 12:31 PM, Matthew Garrett <mjg59@google.com> wrote:
>
>> This is all theoretical security masturbation. The _real_ attacks have
>> been elsewhere.
>
> People made the same argument about Secure Boot, and then we
> discovered that people *were* attacking the boot chain. As we secure
> other components, the attackers move elsewhere. This is an attempt to
> block off an avenue of attack before it's abused.

The thing is, if you have attested the system from boot, then you've
already attested the firmware before it even gets loaded.

And if you haven't, then you can't trust anything else anyway.

So I really don't see your point.

             Linus
