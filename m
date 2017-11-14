From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Tue, 14 Nov 2017 13:38:56 +0100
Message-ID: <20171114123856.GA31142@kroah.com>
References: <20171108194626.GQ22894@wotan.suse.de>
 <20171109014841.GF7859@linaro.org>
 <1510193857.4484.95.camel@linux.vnet.ibm.com>
 <20171109044619.GG7859@linaro.org>
 <20171111023240.2398ca55@alans-desktop>
 <20171113174250.GA22894@wotan.suse.de>
 <20171113210848.4dc344bd@alans-desktop>
 <454.1510609487@warthog.procyon.org.uk>
 <CA+55aFzrK29hbxoKs3GsvVUY4_uR7aBgZv2eeVyVq7MzfATY3w@mail.gmail.com>
 <1510662098.3711.139.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1510662098.3711.139.camel@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Howells <dhowells@redhat.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Jan Blunck <jblunck@infradead.org>, Julia Lawall <julia.lawall@lip6.fr>, Marcus Meissner <meissner@suse.de>, Gary Lin <GLin@suse.com>, LSM List <linux-security-module@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@google.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 14, 2017 at 07:21:38AM -0500, Mimi Zohar wrote:
> On Mon, 2017-11-13 at 14:09 -0800, Linus Torvalds wrote:
> > On Mon, Nov 13, 2017 at 1:44 PM, David Howells <dhowells@redhat.com> wrote:
> > >
> > > Whilst that may be true, we either have to check signatures on every bit of
> > > firmware that the appropriate driver doesn't say is meant to be signed or not
> > > bother.
> > 
> > I vote for "not bother".
> > 
> > Seriously, if you have firmware in /lib/firmware, and you don't trust
> > it, what the hell are you doing?
> 
> I might "trust" the files in /lib/firmware, but I also want to make
> sure that they haven't changed.  File signatures provide file
> provenance and integrity guarantees.

Then "verify" them with signatures that you generate yourself.  Like
dm-verify does for the partition that you put the firmware on.

thanks,

greg k-h
