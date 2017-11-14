From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Tue, 14 Nov 2017 07:21:38 -0500
Message-ID: <1510662098.3711.139.camel@linux.vnet.ibm.com>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
         <14219.1509660259@warthog.procyon.org.uk>
         <1509660641.3416.24.camel@linux.vnet.ibm.com>
         <20171107230700.GJ22894@wotan.suse.de> <20171108061551.GD7859@linaro.org>
         <20171108194626.GQ22894@wotan.suse.de> <20171109014841.GF7859@linaro.org>
         <1510193857.4484.95.camel@linux.vnet.ibm.com>
         <20171109044619.GG7859@linaro.org> <20171111023240.2398ca55@alans-desktop>
         <20171113174250.GA22894@wotan.suse.de>
         <20171113210848.4dc344bd@alans-desktop>
         <454.1510609487@warthog.procyon.org.uk>
         <CA+55aFzrK29hbxoKs3GsvVUY4_uR7aBgZv2eeVyVq7MzfATY3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzrK29hbxoKs3GsvVUY4_uR7aBgZv2eeVyVq7MzfATY3w@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, David Howells <dhowells@redhat.com>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jan Blunck <jblunck@infradead.org>, Julia Lawall <julia.lawall@lip6.fr>, Marcus Meissner <meissner@suse.de>, Gary Lin <GLin@suse.com>, LSM List <linux-security-module@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@google.com>
List-Id: linux-efi@vger.kernel.org

On Mon, 2017-11-13 at 14:09 -0800, Linus Torvalds wrote:
> On Mon, Nov 13, 2017 at 1:44 PM, David Howells <dhowells@redhat.com> wrote:
> >
> > Whilst that may be true, we either have to check signatures on every bit of
> > firmware that the appropriate driver doesn't say is meant to be signed or not
> > bother.
> 
> I vote for "not bother".
> 
> Seriously, if you have firmware in /lib/firmware, and you don't trust
> it, what the hell are you doing?

I might "trust" the files in /lib/firmware, but I also want to make
sure that they haven't changed.  File signatures provide file
provenance and integrity guarantees.

Mimi

