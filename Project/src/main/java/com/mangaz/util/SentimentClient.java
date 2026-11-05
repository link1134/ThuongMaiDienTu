package com.mangaz.util;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

public class SentimentClient {
    private static final String API_URL = "http://127.0.0.1:5000/predict";
    private static final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(3))
            .build();

    /**
     * Gửi câu bình luận sang Python Flask API để nhận diện cảm xúc
     *
     * @param text Nội dung bình luận
     * @return "POSITIVE", "NEGATIVE", hoặc "NEUTRAL"
     */
    public static String analyzeSentiment(String text) {
        if (text == null || text.trim().isEmpty()) {
            return "NEUTRAL";
        }

        try {
            // Chuẩn hóa chuỗi tránh lỗi cú pháp JSON
            String escapedText = text.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\r", "")
                    .replace("\n", " ");

            String jsonPayload = String.format("{\"text\": \"%s\"}", escapedText);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(API_URL))
                    .header("Content-Type", "application/json; charset=UTF-8")
                    .timeout(Duration.ofSeconds(3))
                    .POST(HttpRequest.BodyPublishers.ofString(jsonPayload))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                String responseBody = response.body();
                // Parse thủ công: Kiểm tra chuỗi trả về chứa nhãn nào
                if (responseBody.contains("\"POSITIVE\"")) {
                    return "POSITIVE";
                } else if (responseBody.contains("\"NEGATIVE\"")) {
                    return "NEGATIVE";
                }
            }
        } catch (Exception e) {
            System.err.println("Không kết nối được với Python Sentiment API: " + e.getMessage());
        }

        return "NEUTRAL"; // Trả về mặc định nếu API lỗi hoặc không xác định
    }

    /**
     * Hàm Test
     */
    public static void main(String[] args) {
        // Gộp tất cả các test case vào một mảng để dễ dàng lặp và quản lý
        String[] testCases = {
                // 🔴 CẢM XÚC TIÊU CỰC (NEGATIVE)
                "truyện này giao hàng tới bị mất trang bìa",
                "Shop giao nhầm tập 5 thành tập 6, nhắn tin không thèm trả lời.",
                "Sách cũ nát, gáy bị bung keo, thất vọng thật sự.",
                "Giao hàng chậm như rùa, bọc hàng sơ sài làm móp hết 4 góc truyện.",
                "Truyện bị ố vàng nhiều, không đúng như mô tả trên bài đăng.",

                // 🟢 CẢM XÚC TÍCH CỰC (POSITIVE)
                "Giao hàng rất nhanh",
                "Sách bọc chống sốc 3 lớp siêu cẩn thận, nguyên seal không xước.",
                "Shop uy tín, hỗ trợ nhiệt tình, mua ở đây rất yên tâm.",
                "Chất lượng truyện tuyệt vời, giấy thơm, hình in sắc nét.",
                "Giao đúng tập mình thiếu, giá hợp lý, vote shop 5 sao luôn.",

                // ⚪ CẢM XÚC TRUNG TÍNH (NEUTRAL)
                "Shop ơi bộ này còn hàng không?",
                "Phí ship bộ này về Hà Nội là bao nhiêu vậy shop?",
                "Sách này in tái bản hay bản in đầu năm 2010 vậy bạn?",
                "Tình trạng truyện ở mức đọc được, tạm ổn trong tầm giá.",
                "Shop có nhận xé lẻ tập 2 và 3 để bán không?",

                // ⚠️ CÂU GHÉP & TỪ PHỦ ĐỊNH (Khó)
                "Gáy sách không bị rách, còn nguyên vẹn.",
                "Giao nhanh nhưng sách bị rách mép.",
                "Chẳng đẹp chút nào, màu in bị mờ nhòe."
        };

        System.out.println("================== KẾT QUẢ PHÂN TÍCH CẢM XÚC ==================");

        // Chạy vòng lặp qua từng câu test
        for (int i = 0; i < testCases.length; i++) {
            String comment = testCases[i];
            String sentiment = analyzeSentiment(comment);

            // Format output gọn gàng: Câu số | NHÃN | Nội dung câu
            System.out.printf("Câu %02d | %-8s | %s%n", (i + 1), sentiment, comment);
        }

        System.out.println("===============================================================");
    }
}