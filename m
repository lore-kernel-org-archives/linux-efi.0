Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=93.77.172.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626230;
	b=3bQXLl+AE30Jybze2oDNyJSPd7ziW43ehd4ChRlFSY3I1LMyWqKOD4rU+oxZlZmVye5U
	 CQADVnlj+pHoC2f77i+lSLHpOcoz3G4du8zJwuqEZfH9t4x/KctnQ1xCj2bLeUARCKQNV
	 UXRUyIRinbGOgYclLr74XB0wxojbxDzto0LktAFS6pn0AeXsmSbT6M30qiNfTf0ETMYhk
	 K8K95aaph9nDAj8t62Auzzyzp51B+smi9DkmRy7vM51SvT6EIAMX3IWiSOEmj4SRNTfP5
	 CJ7STXde3xeSc7MEeyjvo1FpFpjcPLenLpxVjM9Uh9K6w4tUC+CUbg5RAatyM1TRZtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626230;
	h=DMARC-Filter:Received:Received:X-Yandex-Fwd:DKIM-Signature:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=hQzOlpIe7Macc6jkr29wJlXF7KJ+0xfNYtPVrAFrPjI=;
	b=kdrksESH55L+S1qcdzUSL3yi+ESip0/A2RIOPKCnXuEJwJhGbdoRR1ccZYQCnQe87Iqk
	 BMUHEFehO/lS2qMBVaoX/JGOyJirX3xB44I1FgY+uSd8QYSXtSdPK0bPjl18mNl8WYRXu
	 D3WTjja44XAkABFrFaSEP0eMkbFA5artjouweNdnA0TgCmyKsuqR6l38lkAwdQRdg0iTw
	 M2dKUyAmaWg+Olc/MyxAkYVJbOOasqAg0kJrP8RKrSXvDYYhM061mUDLyJsqsWcE3f8ln
	 br0MmcM4ktiRZ4fxadysYdLcjfmMAfFV9j+/HxN+DdpWVyiL7pvxK+16eHLdMOAcWHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yandex-team.ru;
	spf=pass smtp.mailfrom=yandex-team.ru;
	dkim=pass header.d=yandex-team.ru header.i=@yandex-team.ru header.a=rsa-sha256 header.s=default header.b=sp3XbSIG;
	arc=none smtp.remote-ip=93.77.172.4
Received: from forwardcorp1e.mail.yandex.net (forwardcorp1e.mail.yandex.net [93.77.172.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAF7606A327;
	Wed, 25 Nov 2026 17:03:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DAAF7606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.a=rsa-sha256 header.s=default header.b=sp3XbSIG
Received: from mail-nwsmtp-smtp-corp-main-80 (mail-nwsmtp-smtp-corp-main-80.yp-c.yandex.net)
	by forwardcorp1e.mail.yandex.net (postfix) with ESMTPS id E617B10031F;
	Wed, 25 Nov 2026 20:03:40 +0300 (MSK)
Received: from [127.0.1.1]
	by mail-nwsmtp-smtp-corp-main-80 with ESMTPSA id a3lrP22Zo8c0-skm5dOxa;
	Wed, 25 Nov 2026 20:03:40 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1795626220;
	bh=hQzOlpIe7Macc6jkr29wJlXF7KJ+0xfNYtPVrAFrPjI=;
	h=Cc:In-Reply-To:Message-Id:To:Date:References:From:Subject;
	b=sp3XbSIGnCe95K7Azy4+apRXQGPldONKo8EZZtcR4MkhxVqr3LriDbkYR32FY7j4Y
	 +71vB4RUEowKwoKeP4+Zk5h1OaiOwBbgn0E8m8xHsRRINjGS2gGpI168gP5Fvcdgsg
	 MSGOLn/dML7TTkDQFYBiV2qytGraDEhHl3GY7BaE=
Authentication-Results: mail-nwsmtp-smtp-corp-main-80; dkim=pass header.i=@yandex-team.ru
From: Mikhail Rudenko <xyzzy@yandex-team.ru>
Date: Wed, 25 Nov 2026 20:03:25 +0300
Subject: [PATCH 1/3] efi: earlycon: unmap framebuffer when the console is
 unregistered
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-efi-earlycon-v1-1-49ac2c0a430b@yandex-team.ru>
References: <20261125-efi-earlycon-v1-0-49ac2c0a430b@yandex-team.ru>
In-Reply-To: <20261125-efi-earlycon-v1-0-49ac2c0a430b@yandex-team.ru>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Thomas Zimmermann <tzimmermann@suse.de>, 
 Javier Martinez Canillas <javierm@redhat.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, Peter Jones <pjones@redhat.com>, 
 Helge Deller <deller@gmx.de>, Hans de Goede <hansg@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org, 
 linux-doc@vger.kernel.org, Mikhail Rudenko <xyzzy@yandex-team.ru>
X-Mailer: b4 0.15.2

EFI earlycon currently unmaps its framebuffer at a late initcall only if
the boot console has already been unregistered. With keep_bootcon, the
console is still registered at that point, so the mapping is retained.

Move the unmap to the console exit callback. This ties the mapping's
lifetime to the console's lifetime and releases it after console writers
have stopped. Clear the saved console pointer on exit.

Signed-off-by: Mikhail Rudenko <xyzzy@yandex-team.ru>
---
 drivers/firmware/efi/earlycon.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/earlycon.c b/drivers/firmware/efi/earlycon.c
index 3d060d59968cf..3a6eaf5481f40 100644
--- a/drivers/firmware/efi/earlycon.c
+++ b/drivers/firmware/efi/earlycon.c
@@ -14,7 +14,7 @@
 
 #include <asm/early_ioremap.h>
 
-static const struct console *earlycon_console __initdata;
+static struct console *earlycon_console;
 static const struct font_desc *font;
 static u16 cur_line_y, max_line_y;
 static u32 efi_x_array[1024];
@@ -44,14 +44,15 @@ static int __init efi_earlycon_remap_fb(void)
 }
 early_initcall(efi_earlycon_remap_fb);
 
-static int __init efi_earlycon_unmap_fb(void)
+static int efi_earlycon_exit(struct console *con)
 {
-	/* unmap the bootconsole fb unless keep_bootcon left it registered */
-	if (efi_fb && !console_is_registered(earlycon_console))
+	if (efi_fb) {
 		memunmap(efi_fb);
+		efi_fb = NULL;
+	}
+	WRITE_ONCE(earlycon_console, NULL);
 	return 0;
 }
-late_initcall(efi_earlycon_unmap_fb);
 
 static __ref void *efi_earlycon_map(unsigned long start, unsigned long len)
 {
@@ -269,6 +270,7 @@ static int __init efi_earlycon_setup(struct earlycon_device *device,
 		efi_earlycon_scroll_up(si);
 
 	device->con->write = efi_earlycon_write;
+	device->con->exit = efi_earlycon_exit;
 	earlycon_console = device->con;
 	return 0;
 }

-- 
2.56.1

