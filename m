From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/8] efi: Get the secure boot status [ver #6]
Date: Tue, 31 Jan 2017 14:02:56 +0000
Message-ID: <5842.1485871376@warthog.procyon.org.uk>
References: <20170127140101.GD31613@codeblueprint.co.uk>
 <20170123212642.GA2766@codeblueprint.co.uk>
 <20170116144954.GB27351@codeblueprint.co.uk>
 <20170111143304.GA29649@codeblueprint.co.uk>
 <148120020832.5854.5448601415491330495.stgit@warthog.procyon.org.uk>
 <148120024570.5854.10638278395097394138.stgit@warthog.procyon.org.uk>
 <7948.1484148443@warthog.procyon.org.uk>
 <794.1484581158@warthog.procyon.org.uk>
 <6306.1485209503@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170127140101.GD31613@codeblueprint.co.uk>
Content-ID: <5841.1485871376.1@warthog.procyon.org.uk>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-efi@vger.kernel.org, ard.biesheuvel@linaro.org, Peter Jones <pjones@redhat.com>, linux-kernel@vger.kernel.org, Michael Chang <mchang@suse.com>, dhowells@redhat.com, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

Matt Fleming <matt@codeblueprint.co.uk> wrote:

> -  grub_memcpy (params, &lh, 2 * 512);
> +  grub_memcpy (params, (grub_uint8_t *)&lh[512], 512);

It would appear this change is wrong and params needs to be changed to params
+ 512 or something similar.

David
