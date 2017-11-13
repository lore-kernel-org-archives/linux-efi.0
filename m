From: David Howells <dhowells@redhat.com>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel lockdown
Date: Mon, 13 Nov 2017 21:44:47 +0000
Message-ID: <454.1510609487@warthog.procyon.org.uk>
References: <20171113210848.4dc344bd@alans-desktop> <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <14219.1509660259@warthog.procyon.org.uk> <1509660641.3416.24.camel@linux.vnet.ibm.com> <20171107230700.GJ22894@wotan.suse.de> <20171108061551.GD7859@linaro.org> <20171108194626.GQ22894@wotan.suse.de> <20171109014841.GF7859@linaro.org> <1510193857.4484.95.camel@linux.vnet.ibm.com> <20171109044619.GG7859@linaro.org> <20171111023240.2398ca55@alans-desktop> <20171113174250.GA22894@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20171113210848.4dc344bd@alans-desktop>
Content-ID: <453.1510609487.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, "Luis R. Rodriguez" <mcgrof@kernel.org>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jan Blunck <jblunck@infradead.org>, Julia Lawall <julia.lawall@lip6.fr>, Marcus Meissner <meissner@suse.de>, Gary Lin <GLin@suse.com>, linux-security-module@vger.kernel.org, linux-efi <linux-efi@vger.kernel.org>, linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@google.com>
List-Id: linux-efi@vger.kernel.org

Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:

> So you don't actually need to sign a lot of PC class firmware because
> it's already signed.

Whilst that may be true, we either have to check signatures on every bit of
firmware that the appropriate driver doesn't say is meant to be signed or not
bother.

David
