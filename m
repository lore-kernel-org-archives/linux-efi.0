From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: Do Qualcomm drivers use DMA buffers for
 request_firmware_into_buf()?
Date: Thu, 28 Jun 2018 01:50:16 +0200
Message-ID: <20180627235016.GD21242@wotan.suse.de>
References: <20180607161847.GN510@tuxbook-pro>
 <CAKv+Gu8+Fq7BD4XD-YCyXzZh0mg6Z2k-0styj0cw6_uZfaqy4Q@mail.gmail.com>
 <20180607163308.GA18834@kroah.com>
 <20180607182117.GR510@tuxbook-pro>
 <CAKv+Gu9yfa=dP-5Fzv8-E6O23zPJXJqquTAt6gCqYyt3OowkvA@mail.gmail.com>
 <20180626000808.GE1860@tuxbook-pro>
 <20180627180059.GA21242@wotan.suse.de>
 <CAKv+Gu-CZpr_tBs_+xz2uGAXcO5k5nKnfeqiD0qtH1AAfgU8+w@mail.gmail.com>
 <20180627233331.GC21242@wotan.suse.de>
 <CAKv+Gu-mnjxFYwPZdGtgo5-mNhNgNih0BVxWxROVUzjqdBA9QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-mnjxFYwPZdGtgo5-mNhNgNih0BVxWxROVUzjqdBA9QQ@mail.gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Will Deacon <will.deacon@arm.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, David Howells <dhowells@redhat.com>, David Brown <david.brown@linaro.org>, Peter Jones <pjones@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>, linux-security-module <linux-security-module@vger.kernel.org>, Nicolas Broeking <nbroeking@me.com>, Jonathan Corbet <corbet@lwn.net>, the arch/x86 maintainers <x86@kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Ingo Molnar <mingo@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Andy Gross <andy.gross@linaro.org>, Darren Hart <dvhart@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, platform-driver-x86@vger.kernel.org, Arend Van Spriel <arend.vanspriel@broadcom.com>, Todd Kjos <tkjos@android.com>, Kees
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 28, 2018 at 01:42:52AM +0200, Ard Biesheuvel wrote:
> But what point is there to letting LSMs decide that they do not trust
> an I/O device if there is nothing we can do about it? How can we
> prevent such an I/O device from modifying our memory?

Simply LSMs can opt to not trust such setup. Its their choice.
The solution to addressing the concern is orthogonal to their
choice.

  Luis
