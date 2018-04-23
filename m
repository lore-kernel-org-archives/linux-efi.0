From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 1/5] efi: Export boot-services code and data as
 debugfs-blobs
Date: Mon, 23 Apr 2018 13:55:16 +0200
Message-ID: <20180423115516.GA7951@kroah.com>
References: <20180408174014.21908-1-hdegoede@redhat.com>
 <20180408174014.21908-2-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180408174014.21908-2-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, dmitry.torokhov@gmail.com, mfuzzey@parkeon.com, keescook@chromium.org, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <aren>
List-Id: linux-efi@vger.kernel.org

On Sun, Apr 08, 2018 at 07:40:10PM +0200, Hans de Goede wrote:
> Sometimes it is useful to be able to dump the efi boot-services code and
> data. This commit adds these as debugfs-blobs to /sys/kernel/debug/efi,
> but only if efi=debug is passed on the kernel-commandline as this requires
> not freeing those memory-regions, which costs 20+ MB of RAM.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

For the debugfs interaction:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
