From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v3 2/5] efi: Add embedded peripheral firmware support
Date: Mon, 23 Apr 2018 21:11:43 +0000
Message-ID: <20180423211143.GZ14440@wotan.suse.de>
References: <20180408174014.21908-1-hdegoede@redhat.com>
 <20180408174014.21908-3-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180408174014.21908-3-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Josh Triplett <josh@joshtriplett.org>, dmitry.torokhov@gmail.com, mfuzzey@parkeon.com, keescook@chromium.org, Kalle Valo <kvalo@codeaurora.org>, Arend
List-Id: linux-efi@vger.kernel.org

Hans, please see use of READING_FIRMWARE_PREALLOC_BUFFER, we'll need a new ID
and security for this type of request so IMA can reject it if the policy is
configured for it.

Please Cc Kees in future patches.

  Luis
